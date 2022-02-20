module Authenticator
  def login
    user = User.find_by(email: auth_params[:email])

    return head(:unauthorized) unless user&.authenticate(auth_params[:password])
    return head(:forbidden) unless user&.activated?

    render(json: { token: user.create_token })
  end

  def activate_user
    user = User.find_from_token(activate_params[:token])

    return head(:conflict) if user.activated? || user.other_activated_user?

    user.update(activated: true)
    head(:ok)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    head(:unauthorized) # tokenが不正かuserが見つからない
  end
end
