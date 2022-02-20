module Authenticator
  def activate_user
    user = User.find_from_token(activate_params[:token])
    if user.activated? || user.other_activated_user?
      head(:conflict) # 既にactivateされている
    else
      user.update(activated: true)
      head(:ok)
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    head(:unauthorized) # tokenが不正かuserが見つからない
  end
end
