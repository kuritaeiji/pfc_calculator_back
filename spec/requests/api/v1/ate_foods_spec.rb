require 'rails_helper'

RSpec.describe 'Api::V1::AteFoods', type: :request do
  describe('GET /api/v1/days/:day_date/ate_foods') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('dayオブジェクトが存在する場合') do
        let(:day) { create(:day, user: user) }
        let!(:ate_foods) { create_list(:ate_food, 3, day: day) }

        it('ate_foodオブジェクトを返す') do
          get("/api/v1/days/#{day.date}/ate_foods", headers: login_header(user))
          expect(status).to eq(200)
          expect(json['ate_foods'].length).to eq(3)
          ate_food = json['ate_foods'][0]
          expect(ate_food['day'].nil?).to eq(false)
          expect(ate_food['food'].nil?).to eq(false)
          expect(ate_food['food']['calory'].nil?).to eq(false)
          expect(ate_food['food']['protein'].nil?).to eq(false)
          expect(ate_food['food']['fat'].nil?).to eq(false)
          expect(ate_food['food']['carbonhydrate'].nil?).to eq(false)
        end
      end

      context('dayオブジェクトが存在しない場合') do
        it('404レスポンスを返す') do
          get('/api/v1/days/2020-02-02/ate_foods', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/days/2020-02-02/ate_foods')
        expect(status).to eq(401)
      end
    end
  end

  describe('POST /api/v1/days/:day_date/ate_foods') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('dayオブジェクトが存在する場合') do
        let(:day) { create(:day, user: user) }
        let(:path) { "/api/v1/days/#{day.date}/ate_foods" }

        context('カレントユーザーがfoodの所有者である場合') do
          let(:category) { create(:category, user: user) }
          let(:food) { create(:food, category: category) }

          context('有効なパラメーターの場合') do
            let(:params) { { ate_food: { amount: 100, food_id: food.id } } }

            it('ate_foodを作成する') do
              expect do
                post(path, headers: login_header(user), params: params)
              end.to change(day.ate_foods, :count).by(1)
            end

            it('ate_foodを返す') do
              post(path, headers: login_header(user), params: params)
              expect(json['ate_food']['amount']).to eq('100.0')
              expect(status).to eq(200)
            end
          end

          context('無効なパラメーターの場合') do
            let(:params) { { ate_food: { amount: nil, food_id: food.id } } }

            it('バリデーションエラーを返す') do
              post(path, headers: login_header(user), params: params)
              expect(status).to eq(400)
              expect(json[0]).to include(I18n.t('errors.messages.blank'))
            end
          end
        end

        context('カレントユーザーがfoodの所有者でない場合') do
          it('401レスポンスを返す') do
            post(path, headers: login_header(user), params: { ate_food: { food_id: 1 } })
            expect(status).to eq(401)
          end
        end
      end

      context('dayオブジェクトが存在しない場合') do
        it('404レスポンスを返す') do
          post('/api/v1/days/2020-02-02/ate_foods', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        post('/api/v1/days/2020-02-02/ate_foods')
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/ate_foods/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('ate_foodが存在している場合') do
        let(:path) { "/api/v1/ate_foods/#{ate_food.id}" }

        context(':idがカレントユーザーが所有しているate_foodの場合') do
          let(:day) { create(:day, user: user) }
          let(:ate_food) { create(:ate_food, day: day) }

          context('paramsのfood_idがカレントユーザーの所有しているfoodの場合') do
            let(:category) { create(:category, user: user) }
            let(:food) { create(:food, category: category) }

            context('有効なパラメーターの場合') do
              let(:params) { { ate_food: { amount: 1111, food_id: food.id } } }

              it('ate_foodを更新する') do
                put(path, headers: login_header(user), params: params)
                expect(ate_food.reload.amount).to eq(1111)
              end

              it('ate_foodを返す') do
                put(path, headers: login_header(user), params: params)
                expect(json['ate_food']['id']).to eq(ate_food.id)
              end
            end

            context('無効なパラメーターの場合') do
              let(:params) { { ate_food: { amount: nil, food_id: food.id } } }

              it('バリデーションメッセージを返す') do
                put(path, headers: login_header(user), params: params)
                expect(status).to eq(400)
                expect(json[0]).to include(I18n.t('errors.messages.blank'))
              end
            end
          end

          context('paramsのfood_idがカレントユーザーの所有していないfoodの場合') do
            let(:food) { create(:food) }
            let(:params) { { ate_food: { amount: 100, food_id: food.id } } }

            it('401レスポンスを返す') do
              put(path, headers: login_header(user), params: params)
              expect(status).to eq(401)
            end
          end
        end

        context(':idがカレントユーザーの所有しているate_foodではない場合') do
          let(:ate_food) { create(:ate_food) }

          it('401レスポンスを返す') do
            put("/api/v1/ate_foods/#{ate_food.id}", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('ate_foodが存在しない場合') do
        it('404レスポンスを返す') do
          put('/api/v1/ate_foods/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        put('/api/v1/ate_foods/1')
        expect(status).to eq(401)
      end
    end
  end

  describe('DELETE /api/v1/ate_foods/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('ate_foodが存在している場合') do
        let(:path) { "/api/v1/ate_foods/#{ate_food.id}" }

        context(':idがカレントユーザーのate_foodである場合') do
          let(:day) { create(:day, user: user) }
          let!(:ate_food) { create(:ate_food, day: day) }

          it('ate_foodを削除する') do
            expect do
              delete(path, headers: login_header(user))
            end.to change(day.ate_foods, :count).by(-1)
          end
        end

        context(':idがカレントユーザーのate_foodでない場合') do
          let(:ate_food) { create(:ate_food) }

          it('401レスポンスを返す') do
            delete(path, headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('ate_foodが存在しない場合') do
        it('404レスポンスを返す') do
          delete('/api/v1/ate_foods/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        delete('/api/v1/ate_foods/1')
        expect(status).to eq(401)
      end
    end
  end
end
