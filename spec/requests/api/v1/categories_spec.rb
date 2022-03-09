require 'rails_helper'

RSpec.describe 'Api::V1::Categories', type: :request do
  describe('GET /api/v1/categories') do
    let(:path) { '/api/v1/categories' }

    context('ログインしている場合') do
      let!(:user) { create(:user, :with_categories) }

      it('カテゴリー一覧を返す') do
        get(path, headers: login_header(user))
        expect(json['categories'][0]['title']).to include('カテゴリー')
        expect(json['categories'][0]['id'].present?).to eq(true)
        expect(json['categories'].length).to eq(3)
      end
    end

    context('ログインしていない場合') do
      context('有効期限が切れている場合') do
        it('401エラーを返し、バリデーションメッセージを返す') do
          user = create(:user)
          token = user.create_token

          Timecop.travel(Time.now + 1.year)
          get(path, headers: { Authorization: "Bearer #{token}" })
          expect(status).to eq(401)
          expect(json['message']).to eq('有効期限が切れています。再度ログインして下さい。')
        end
      end

      context('tokenがない場合') do
        it('401エラーを返す') do
          get(path)
          expect(status).to eq(401)
          expect(response.body).to eq('')
        end
      end
    end
  end

  describe('POST /api/v1/categories') do
    let(:path) { '/api/v1/categories' }

    context('ログインしている場合') do
      let!(:user) { create(:user) }

      context('有効なパラメーターの場合') do
        let(:params) { { category: { title: 'カテゴリー' } } }

        it('作成したカテゴリーを返す') do
          post(path, headers: login_header(user), params: params)
          expect(json['category']['title']).to eq('カテゴリー')
        end

        it('カテゴリーを作成する') do
          expect do
            post(path, headers: login_header(user), params: params)
          end.to change(Category, :count).by(1)
        end
      end

      context('無効なパラメーターの場合') do
        let(:params) { { category: { title: '' } } }

        it('400レスポンスを返す') do
          post(path, headers: login_header(user), params: params)
          expect(status).to eq(400)
          expect(json[0]).to include(I18n.t('errors.messages.blank'))
        end
      end
    end

    context('ログインしていない場合') do
      it('401エラーを返す') do
        post(path)
        expect(status).to eq(401)
      end
    end
  end

  describe('PUT /api/v1/categories/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('カテゴリーが見つかる場合') do
        context('カレントユーザーの所有しているカテゴリーの場合') do
          let!(:category) { create(:category, user: user) }

          context('有効なパラメーターの場合') do
            let(:params) { { category: { title: 'new_title' } } }

            it('更新したカテゴリーを返す') do
              put("/api/v1/categories/#{category.id}", headers: login_header(user), params: params)
              expect(json['category']['title']).to eq('new_title')
            end

            it('カテゴリーを更新する') do
              put("/api/v1/categories/#{category.id}", headers: login_header(user), params: params)
              expect(category.reload.title).to eq('new_title')
            end
          end

          context('無効なパラメーターの場合') do
            let(:params) { { category: { title: '' } } }

            it('カテゴリーを更新できない') do
              title = category.title
              put("/api/v1/categories/#{category.id}", headers: login_header(user), params: params)
              expect(category.reload.title).to eq(title)
            end

            it('バリデーションメッセージを返す') do
              put("/api/v1/categories/#{category.id}", headers: login_header(user), params: params)
              expect(status).to eq(400)
              expect(json[0]).to include(I18n.t('errors.messages.blank'))
            end
          end
        end

        context('カレントユーザーの所有していないカテゴリーの場合') do
          let(:category) { create(:category) }

          it('404レスポンスを返す') do
            put("/api/v1/categories/#{category.id}", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('カテゴリーが見つからない場合') do
        it('404レスポンスを返す') do
          put('/api/v1/categories/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401エラーを返す') do
        put('/api/v1/categories/1')
        expect(status).to eq(401)
      end
    end
  end

  describe('DELETE /api/v1/category/:id') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('カテゴリーが見つかる場合') do
        context('カレントユーザーが所有しているカテゴリーの場合') do
          let!(:category) { create(:category, user: user) }

          it('カテゴリーを削除する') do
            expect do
              delete("/api/v1/categories/#{category.id}", headers: login_header(user))
            end.to change(user.categories, :count).by(-1)
            expect(status).to eq(200)
          end
        end

        context('カレントユーザーが所有していないカテゴリーの場合') do
          let!(:category) { create(:category) }
          let(:params) { { category: { title: 'new_title' } } }

          it('404レスポンスを返す') do
            delete("/api/v1/categories/#{category.id}", headers: login_header(user))
            expect(status).to eq(404)
          end
        end
      end

      context('カテゴリーが見つからない場合') do
        it('404レスポンスを返す') do
          delete('/api/v1/categories/1', headers: login_header(user))
          expect(status).to eq(404)
        end
      end
    end

    context('ログインしていない場合') do
      it('401エラーを返す') do
        delete('/api/v1/categories/1')
        expect(status).to eq(401)
      end
    end
  end
end
