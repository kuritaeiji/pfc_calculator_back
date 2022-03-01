require 'rails_helper'

RSpec.describe 'Api::V1::Days', type: :request do
  describe('POST /api/v1/days') do
    let(:path) { '/api/v1/days' }

    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('dayオブジェクトが作られていない場合') do
        it('dayオブジェクトが作成される') do
          expect do
            post(path, headers: login_header(user), params: { day: { date: '2022-01-01' } })
          end.to change(user.days, :count).by(1)
          expect(status).to eq(200)
        end

        it('dayオブジェクトが返される') do
          post(path, headers: login_header(user), params: { day: { date: '2022-01-01' } })
          expect(json['day']['id'].nil?).to eq(false)
          expect(json['day']['date'].nil?).to eq(false)
          expect(json['day']['calory']).to eq('0.0')
          expect(json['day']['protein']).to eq('0.0')
          expect(json['day']['fat']).to eq('0.0')
          expect(json['day']['carbonhydrate']).to eq('0.0')
        end
      end

      context('既にdayオブジェクトが作られている場合') do
        let!(:day) { create(:day, date: '2022-01-01', user: user) }

        it('dayオブジェクトが作成されない') do
          expect do
            post(path, headers: login_header(user), params: { day: { date: '2022-01-01' } })
          end.not_to change(user.days, :count)
          expect(status).to eq(200)
        end

        it('dayオブジェクトが返される') do
          post(path, headers: login_header(user), params: { day: { date: '2022-01-01' } })
          expect(json['day'].present?).to eq(true)
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
end
