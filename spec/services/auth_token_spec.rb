require('rails_helper')

RSpec.describe('AuthToken') do
  it('create_token and decode_token') do
    Timecop.freeze(Time.now)
    sub = 1
    lifetime = 1.hour
    token = AuthToken.create_token(sub: sub, lifetime: lifetime)
    payload = AuthToken.decode(token: token)

    expect(payload[:sub]).to eq(sub)
    expect(payload[:exp]).to eq(lifetime.from_now.to_i)
  end

  it('lifetime_string') do
    expect(AuthToken.lifetime_string(lifetime: 1.hour)).to eq('1時間')
  end
end
