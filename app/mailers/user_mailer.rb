class UserMailer < ApplicationMailer
  def activate_user_email
    user = params[:user]
    @token = AuthToken.create_token(sub: user.id, lifetime: default_lifetime)
    @lifetime_string = AuthToken.lifetime_string(lifetime: default_lifetime)
    mail(to: user.email, subject: 'アカウント有効化のお知らせ')
  end

  private

  def default_lifetime
    1.hour
  end
end
