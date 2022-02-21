require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe('POST /api/v1/signup') do
    let(:path) { '/api/v1/signup' }

    context('パラメーターが有効な時') do
      let(:params) { { user: { email: 'user@example.com', password: 'Password1010' } } }

      it('ユーザーを作成する') do
        expect do
          post(path, params: params)
        end.to change(User, :count).by(1)
      end

      it('メールを送信する') do
        expect do
          perform_enqueued_jobs do
            post(path, params: params)
          end
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context('パラメーターが無効な時') do
      it('バリデーションメッセージを返す') do
        post(path, params: { user: { email: '', password: '' } })

        expect(status).to eq(400)
        blank = I18n.t('errors.messages.blank')
        expect(json).to include("メールアドレス#{blank}")
        expect(json).to include("パスワード#{blank}")
      end
    end
  end

  describe('PUT /api/v1/activate') do
    let(:user) { create(:user, activated: false) }
    let(:lifetime) { 1.hour }
    let(:path) { '/api/v1/activate' }

    context('有効なトークン') do
      context('ユーザーが見つかる') do
        context('自分自身が有効化されていない') do
          context('他に同じメアドの有効化されたユーザーがいない') do
            it('ユーザーが有効化される') do
              token = user.create_token(lifetime: lifetime)
              put(path, params: { token: token })
              user.reload
              expect(user.activated?).to eq(true)
            end
          end

          context('他に同じメアドの有効化されたユーザーがいる') do
            it('409エラーを返す') do
              create(:user, email: user.email)
              token = user.create_token(lifetime: lifetime)
              put(path, params: { token: token })
              expect(status).to eq(409)
            end
          end
        end

        context('自分自身が既に有効化されている') do
          it('409エラーを返す') do
            user = create(:user)
            token = user.create_token(lifetime: lifetime)
            put(path, params: { token: token })
            expect(status).to eq(409)
          end
        end
      end

      context('ユーザーが見つからない') do
        it('401エラーを返す') do
          other_user = build(:user)
          token = other_user.create_token(lifetime: lifetime)
          put(path, params: { token: token })
          expect(status).to eq(401)
        end
      end
    end

    context('不正なトークン') do
      it('401エラーが発生する') do
        token = "#{user.create_token(lifetime: lifetime)}hoge"
        put(path, params: { token: token })
        expect(status).to eq(401)
      end
    end
  end

  describe('DELETE /api/v1/withdraw') do
    let(:path) { '/api/v1/withdraw' }

    context('ログインしていない場合') do
      it('401エラーを返す') do
        delete(path)
        expect(status).to eq(401)
      end
    end

    context('ログインしている場合') do
      let!(:user) { create(:user) }

      it('200レスポンスを返す') do
        delete(path, headers: login_header(user))
        expect(status).to eq(200)
      end

      it('ユーザーが削除される') do
        expect do
          delete(path, headers: login_header(user))
        end.to change(User, :count).by(-1)
      end
    end
  end
end
