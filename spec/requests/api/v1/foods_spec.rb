require 'rails_helper'

RSpec.describe 'Api::V1::Foods', type: :request do
  describe('GET /api/v1/foods') do
    let(:path) { '/api/v1/foods' }

    context('ログインしている場合') do
      let(:user) { create(:user, :with_foods) }

      it('フード一覧を返す') do
        get(path, headers: login_header(user))
        expect(status).to eq(200)

        food = json['foods'][0]
        expect(food['title']).to include('フード')
        expect(food['category']['title']).to include('カテゴリー')
        expect(json['foods'].length).to eq(9)
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get(path)
        expect(status).to eq(401)
      end
    end
  end

  describe('POST /api/v1/foods') do
    let(:path) { '/api/v1/foods' }

    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('カレントユーザーが所有しているカテゴリーIDを送信する場合') do
        let(:category) { create(:category, user: user) }

        context('有効なパラメーターの場合') do
          let(:params) { { food: attributes_for(:food, title: 'new_food').merge(category_id: category.id) } }

          it('フードを作成する') do
            expect do
              post(path, headers: login_header(user), params: params)
            end.to change(category.foods, :count).by(1)
          end

          it('フードを返す') do
            post(path, headers: login_header(user), params: params)
            expect(json['food']['title']).to eq('new_food')
            expect(json['food']['category']['id']).to eq(category.id)
            expect(status).to eq(200)
          end
        end

        context('不正なパラメーターの場合') do
          let(:params) { { food: attributes_for(:food, title: '').merge(category_id: category.id) } }

          it('バリデーションメッセージを返す') do
            post(path, headers: login_header(user), params: params)
            expect(status).to eq(400)
            expect(json[0]).to include(I18n.t('errors.messages.blank'))
          end
        end
      end

      context('カレントユーザーが所有していないカテゴリーIDを送信する場合') do
        let(:category) { create(:category) }
        let(:params) { { food: attributes_for(:food, title: '').merge(category_id: category.id) } }

        it('401レスポンスを返す') do
          post(path, headers: login_header(user), params: params)
          expect(status).to eq(401)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        post(path)
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/foods/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('フードが見つかる場合') do
        context('フードがカレントユーザのものであった場合') do
          let(:category) { create(:category, user: user) }
          let(:food) { create(:food, category: category) }

          context('パラメーターのカテゴリーIDがカレントユーザーの所有するカテゴリーだった場合') do
            context('有効なパラメーターであった場合') do
              let(:params) { { food: attributes_for(:food, title: 'new_food').merge(category_id: category.id) } }

              it('フードを更新する') do
                put("/api/v1/foods/#{food.id}", headers: login_header(user), params: params)
                expect(food.reload.title).to eq('new_food')
              end

              it('フードを返す') do
                put("/api/v1/foods/#{food.id}", headers: login_header(user), params: params)
                expect(json['food']['title']).to eq('new_food')
                expect(json['food']['category']['id']).to eq(category.id)
              end
            end

            context('無効なパラメーターであった場合') do
              let(:params) { { food: attributes_for(:food, title: '').merge(category_id: category.id) } }

              it('バリデーションメッセージを返す') do
                put("/api/v1/foods/#{food.id}", headers: login_header(user), params: params)
                expect(status).to eq(400)
                expect(json[0]).to include(I18n.t('errors.messages.blank'))
              end
            end
          end

          context('パラメーターのカテゴリーIDがカレントユーザーの所有するカテゴリーでなかった場合') do
            let(:other_category) { create(:category) }
            let(:params) { { food: attributes_for(:food).merge(category_id: other_category.id) } }

            it('401レスポンスを返す') do
              put("/api/v1/foods/#{food.id}", headers: login_header(user), params: params)
              expect(status).to eq(401)
            end
          end
        end

        context('フードがカレントユーザーのものでなかった場合') do
          let(:food) { create(:food) }

          it('404レスポンスを返す') do
            put("/api/v1/foods/#{food.id}", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('フードが見つからない場合') do
        it('404レスポンスを返す') do
          put('/api/v1/foods/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        put('/api/v1/foods/1')
        expect(status).to eq(401)
      end
    end
  end

  describe('DELETE /api/v1/foods/id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('フードが見つかる場合') do
        context('フードがカレントユーザのものであった場合') do
          let(:category) { create(:category, user: user) }
          let!(:food) { create(:food, category: category) }

          it('フードを削除する') do
            expect do
              delete("/api/v1/foods/#{food.id}", headers: login_header(user))
            end.to change(category.foods, :count).by(-1)
          end
        end

        context('フードがカレントユーザーのものでなかった場合') do
          let(:food) { create(:food) }

          it('404レスポンスを返す') do
            delete("/api/v1/foods/#{food.id}", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('フードが見つからない場合') do
        it('404レスポンスを返す') do
          delete('/api/v1/foods/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        delete('/api/v1/foods/1')
        expect(status).to eq(401)
      end
    end
  end
end
