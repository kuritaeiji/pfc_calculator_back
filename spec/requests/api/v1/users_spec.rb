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
end
