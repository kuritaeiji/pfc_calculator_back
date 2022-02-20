require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_secure_password }

  describe('email validation') do
    it('email is empty') do
      user = build(:user, email: '')
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.blank'))
      expect(user.errors.messages[:email].length).to eq(1)
    end

    it('email is invalid format') do
      user = build(:user, email: 'abcd@abcd')
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.invalid'))
    end

    describe('email is unique in activated users') do
      let(:email) { 'user@example.com' }
      context('すでに同じメアドでアクティブなユーザーがいる時') do
        it('takenエラー') do
          create(:user, email: email)
          user = build(:user, email: email)
          user.valid?
          expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.taken'))
        end
      end

      context('同じメアドでアクティブでないユーザーがいる時') do
        it('エラーなし') do
          create(:user, email: email, activated: false)
          user = build(:user, email: email)
          expect(user.valid?).to eq(true)
        end
      end
    end

    it('email maximum is 255') do
      user = build(:user, email: 'a' * 266)
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.too_long', count: 255))
    end
  end

  describe('password validation') do
    it('password min length is 8') do
      user = build(:user, password: 'Passwo1')
      user.valid?
      expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.too_short', count: 8))
    end

    describe('password format') do
      it('パスワードが三種類含んでないとき') do
        user = build(:user, password: 'Password')
        user.valid?
        expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.password'))
      end

      it('パスワードにハイフンアンダーバー以外が使われるとき') do
        user = build(:user, password: 'Password.')
        user.valid?
        expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.password'))
      end
    end
  end

  describe('other_activated_user?') do
    let(:email) { 'user@example.com' }

    context('他にユーザーがいない場合') do
      it('falseを返す') do
        create(:user, email: email, activated: false)
        user = build(:user, email: email)
        expect(user.other_activated_user?).to eq(false)
      end
    end

    context('他にユーザーがいる場合') do
      it('trueを返す') do
        create(:user, email: email, activated: true)
        user = build(:user, email: email)
        expect(user.other_activated_user?).to eq(true)
      end
    end
  end

  describe('find_from_token_class_method') do
    let(:user) { create(:user) }

    context('不正なトークンの場合') do
      it('JWT::DecodeErrorが発生する') do
        token = "#{AuthToken.create_token(sub: user.id)}hoge"
        expect { User.find_from_token(token) }.to raise_error(JWT::DecodeError)

      end
    end

    context('ユーザーが見つからない場合') do
      it('ActiveRecord::RecordNotFoundエラーが発生する') do
        token = AuthToken.create_token(sub: 0)
        expect { User.find_from_token(token) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context('正しいトークンでユーザーが見つかる場合') do
      it('ユーザーを返す') do
        token = user.create_token
        expect(User.find_from_token(token)).to eq(user)
      end
    end
  end

  describe('create_token') do
    it('トークンを返す') do
      Timecop.freeze(Time.now)
      user = create(:user)
      token = user.create_token
      payload = AuthToken.decode(token: token)

      expect(payload[:sub]).to eq(user.id)
      expect(payload[:exp]).to eq(AuthToken.default_lifetime.from_now.to_i)
    end
  end
end
