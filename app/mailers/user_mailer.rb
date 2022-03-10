class UserMailer < ApplicationMailer
  def activate_user_email
    create_url
    create_lifetime_string
    mail(to: user.email, subject: 'アカウント有効化のお知らせ')
  end

  private

  def create_url
    @url = "#{origin}/activate?token=#{token}"
  end

  def origin
    return 'https://pfc-calculator-front.herokuapp.com' if Rails.env.production?

    'http://localhost:8080'
  end

  def create_lifetime_string
    @lifetime_string = AuthToken.lifetime_string(lifetime: default_lifetime)
  end

  def user
    params[:user]
  end

  def token
    user.create_token(lifetime: default_lifetime)
  end

  def default_lifetime
    1.hour
  end
end
