require 'rails_helper'

RSpec.describe 'Api::V1::Dishes', type: :request do
  describe('GET /api/v1/days/:days_date/dishes') do
    context('ログインしている場合') do
      let(:user) { create(:user) }
      let(:path) { "/api/v1/days/#{day.date}/dishes" }

      context('dayオブジェクトが存在する場合') do
        let(:day) { create(:day, user: user) }
        let!(:dishes) { create_list(:dish, 3, day: day) }

        it('料理を返す') do
          get(path, headers: login_header(user))
          expect(status).to eq(200)
          expect(json['dishes'].length).to eq(3)

          dish = json['dishes'][0]

          expect(dish['title'].nil?).to eq(false)
          expect(dish['calory'].nil?).to eq(false)
          expect(dish['protein'].nil?).to eq(false)
          expect(dish['fat'].nil?).to eq(false)
          expect(dish['carbonhydrate'].nil?).to eq(false)
          expect(dish['day'].nil?).to eq(false)
        end
      end

      context('dayオブジェクトが存在しない場合') do
        let(:day) { create(:day) }

        it('404レスポンスを返す') do
          get(path, headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/days/2020-01-01/dishes')
        expect(status).to eq(401)
      end
    end
  end

  describe('POST /api/v1/days/:day_date/dishes') do
    context('ログインしている場合') do
      let(:user) { create(:user) }
      let(:path) { "/api/v1/days/#{day.date}/dishes" }

      context('dayオブジェクトが存在する場合') do
        let(:day) { create(:day, user: user) }

        context('有効なパラメーターの場合') do
          let(:params) { { dish: attributes_for(:dish) } }

          it('料理を作成する') do
            expect do
              post(path, headers: login_header(user), params: params)
            end.to change(day.dishes, :count).by(1)
          end

          it('作成した料理を返す') do
            post(path, headers: login_header(user), params: params)
            expect(json['dish']['title']).to eq(params[:dish][:title])
            expect(status).to eq(200)
          end
        end

        context('無効なパラメーターの場合') do
          it('バリデーションメッセージを返す') do
            post(path, headers: login_header(user), params: { dish: attributes_for(:dish, title: '') })
            expect(json[0]).to include(I18n.t('errors.messages.blank'))
          end
        end
      end

      context('dayオブジェクトが存在しない場合') do
        let(:day) { create(:day) }

        it('404レスポンスを返す') do
          post(path, headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        post('/api/v1/days/2020-01-01/dishes')
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/dishes/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }
      let(:path) { "/api/v1/dishes/#{dish.id}" }

      context('料理が存在する場合') do
        let(:day) { create(:day, user: user) }
        let(:dish) { create(:dish, day: day) }

        context('有効なパラメーターの場合') do
          let(:params) { { dish: attributes_for(:dish, title: 'new_title') } }

          it('料理を更新する') do
            put(path, headers: login_header(user), params: params)
            expect(dish.reload.title).to eq('new_title')
          end

          it('料理を返す') do
            put(path, headers: login_header(user), params: params)
            expect(status).to eq(200)
            expect(json['dish']['title']).to eq('new_title')
          end
        end

        context('無効なパラメーターの場合') do
          let(:params) { { dish: attributes_for(:dish, title: '') } }

          it('バリデーションメッセージを返す') do
            put(path, headers: login_header(user), params: params)
            expect(status).to eq(400)
            expect(json[0]).to include(I18n.t('errors.messages.blank'))
          end
        end
      end

      context('料理が存在しない場合') do
        let(:dish) { create(:dish) }

        it('404レスポンスを返す') do
          put(path, headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        put('/api/v1/dishes/1')
        expect(status).to eq(401)
      end
    end
  end

  describe('DELETE /api/v1/dishes/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }
      let(:path) { "/api/v1/dishes/#{dish.id}" }

      context('料理が存在する場合') do
        let(:day) { create(:day, user: user) }
        let!(:dish) { create(:dish, day: day) }

        it('料理を削除する') do
          expect do
            delete(path, headers: login_header(user))
          end.to change(day.dishes, :count).by(-1)
        end
      end

      context('料理が存在しない場合') do
        let(:dish) { create(:dish) }

        it('404レスポンスを返す') do
          delete(path, headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        delete('/api/v1/dishes/1')
        expect(status).to eq(401)
      end
    end
  end
end
