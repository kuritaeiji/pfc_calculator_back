require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  it('#activate_user_email') do
    user = build(:user)
    UserMailer.with(user: user).activate_user_email.deliver_now
    mail = ActionMailer::Base.deliveries.last

    expect(mail.from[0]).to eq('pfc-calculator@heroku.com')
    expect(mail.to[0]).to eq(user.email)
    expect(mail.subject).to eq('アカウント有効化のお知らせ')
    expect(mail.body).to match('1時間')
    expect(URI.extract(mail.body.encoded)[0]).to match(/http:\/\/pfc-calculator-back.herokuapp.com\/api\/v1\/activate\?token=/)
  end
end
