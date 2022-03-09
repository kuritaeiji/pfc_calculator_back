module Authenticator
  def login
    user = User.find_by(email: auth_params[:email])

    return head(:unauthorized) unless user&.authenticate(auth_params[:password])
    return head(:forbidden) unless user&.activated?

    render(json: { token: user.create_token })
  end

  def activate_user
    user = fetch_user(activate_params[:token])
    return head(:unauthorized) unless user
    return head(:conflict) if user.activated? || user.other_activated_user?

    user.update(activated: true)
    head(:ok)
  end

  def logged_in_user
    render(status: 401, json: { code: 'expired_token', message: '有効期限が切れています。再度ログインして下さい。' }) if current_user == :expired
    head(401) unless current_user
  end

  def current_user
    @current_user ||= fetch_user(token_from_client)
  end

  private

  def fetch_user(token)
    User.find_from_token(token)
  rescue JWT::ExpiredSignature
    :expired
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end

  def token_from_client
    request.headers[:Authorization]&.sub(/^Bearer /, '')
  end
end
