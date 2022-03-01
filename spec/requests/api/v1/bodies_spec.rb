require 'rails_helper'

RSpec.describe 'Api::V1::Bodies', type: :request do
  describe('POST /api/v1/days/:day_date/bodies') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('dayオブジェクトが存在する場合') do
        let(:day) { create(:day, user: user) }
        let(:path) { "/api/v1/days/#{day.date}/bodies" }

        context('まだbodyオブジェクトが作成されていない場合') do
          it('bodyオブジェクトを作成する') do
            expect do
              post(path, headers: login_header(user))
            end.to change(Body, :count).by(1)
          end

          it('bodyオブジェクトを返す') do
            post(path, headers: login_header(user))
            expect(json['body']['weight']).to eq('0.0')
            expect(json['body']['day']['date']).to eq(day.date.to_s)
            expect(status).to eq(200)
          end
        end

        context('既にbodyオブジェクトが作成されている場合') do
          let!(:body) { create(:body, day: day) }

          it('bodyオブジェクトを作成しない') do
            expect do
              post(path, headers: login_header(user))
            end.not_to change(Body, :count)
          end

          it('bodyオブジェクトを返す') do
            post(path, headers: login_header(user))
            expect(status).to eq(200)
            expect(json['body']['id']).to eq(body.id)
          end
        end
      end

      context('dayオブジェクトが存在しない場合') do
        it('404レスポンスを返す') do
          post('/api/v1/days/1/bodies', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        post('/api/v1/days/1/bodies')
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/bodies/:id/weight') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('bodyが存在している場合') do
        context('カレントユーザーがbodyのオーナーである場合') do
          let(:day) { create(:day, user: user) }
          let(:body) { create(:body, day: day) }
          let(:path) { "/api/v1/bodies/#{body.id}/weight" }

          context('有効なパラメーターの場合') do
            let(:params) { { body: { weight: 1 } } }

            it('bodyを更新する') do
              put(path, headers: login_header(user), params: params)
              expect(body.reload.weight).to eq(1)
            end

            it('bodyを返す') do
              put(path, headers: login_header(user), params: params)
              expect(status).to eq(200)
              expect(json['body']['weight']).to eq('1.0')
              expect(json['body']['day']['id']).to eq(day.id)
            end
          end

          context('無効なパラメーターの場合') do
            let(:params) { { body: { weight: nil } } }

            it('バリデーションメッセージを返す') do
              put(path, headers: login_header(user), params: params)
              expect(json[0]).to include(I18n.t('errors.messages.blank'))
              expect(status).to eq(400)
            end
          end
        end

        context('bodyが他人のものである場合') do
          let(:body) { create(:body) }

          it('404レスポンスを返す') do
            put("/api/v1/bodies/#{body.id}/weight", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('bodyが存在しない場合') do
        it('404レスポンスを返す') do
          put('/api/v1/bodies/1/weight', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        put('/api/v1/bodies/1/weight')
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/bodies/:id/percentage') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('bodyが存在している場合') do
        context('カレントユーザーがbodyのオーナーである場合') do
          let(:day) { create(:day, user: user) }
          let(:body) { create(:body, day: day) }
          let(:path) { "/api/v1/bodies/#{body.id}/percentage" }

          context('有効なパラメーターの場合') do
            let(:params) { { body: { percentage: 1 } } }

            it('bodyを更新する') do
              put(path, headers: login_header(user), params: params)
              expect(body.reload.percentage).to eq(1)
            end

            it('bodyを返す') do
              put(path, headers: login_header(user), params: params)
              expect(status).to eq(200)
              expect(json['body']['percentage']).to eq('1.0')
              expect(json['body']['day']['id']).to eq(day.id)
            end
          end

          context('無効なパラメーターの場合') do
            let(:params) { { body: { percentage: nil } } }

            it('バリデーションメッセージを返す') do
              put(path, headers: login_header(user), params: params)
              expect(json[0]).to include(I18n.t('errors.messages.blank'))
              expect(status).to eq(400)
            end
          end
        end

        context('bodyが他人のものである場合') do
          let(:body) { create(:body) }

          it('404レスポンスを返す') do
            put("/api/v1/bodies/#{body.id}/percentage", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('bodyが存在しない場合') do
        it('404レスポンスを返す') do
          put('/api/v1/bodies/1/percentage', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        put('/api/v1/bodies/1/percentage')
        expect(status).to eq(401)
      end
    end
  end
end
