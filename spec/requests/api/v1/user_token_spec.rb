require 'rails_helper'

RSpec.describe 'Api::V1::UserTokens', type: :request do
  describe('POST /api/v1/login') do
    let(:email) { 'test@example.com' }
    let(:password) { 'Password1010' }
    let!(:user) { create(:user, email: email, password: password) }
    let(:path) { '/api/v1/login' }

    context('メールアドレスでユーザーが発見できる場合') do
      context('パスワードが正しい場合') do
        context('有効化されている場合') do
          it('トークンを返す') do
            post(path, params: { auth: { email: email, password: password } })
            expect(status).to eq(200)
            expect(User.find_from_token(json['token'])).to eq(user)
          end
        end

        context('有効化されていない場合') do
          it('403エラーを返す') do
            create(:user, email: "#{email}a", password: password, activated: false)
            post(path, params: { auth: { email: "#{email}a", password: password } })
            expect(status).to eq(403)
          end
        end
      end

      context('パスワードが正しくない場合') do
        it('401エラーを返す') do
          post(path, params: { auth: { email: email, password: 'invalid_password' } })
          expect(status).to eq(401)
        end
      end
    end

    context('メールアドレスでユーザーが発見できない場合') do
      it('401エラーを返す') do
        post(path, params: { auth: { email: 'invalid_email', password: password } })
        expect(status).to eq(401)
      end
    end
  end
end
