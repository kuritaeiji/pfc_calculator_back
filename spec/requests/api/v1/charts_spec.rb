require 'rails_helper'

RSpec.describe 'Api::V1::Charts', type: :request do
  describe('GET /api/v1/charts/date_weight') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      context('全ての日付のデーターが存在する場合') do
        it('チャートデータを返す') do
          (1..10).each do |n|
            day = create(:day, user: user, date: Date.new(2020, 2, n))
            create(:body, day: day, weight: n)
          end

          chart_data = (1..10).map { |n| "#{n}.0" }
          get('/api/v1/charts/date_weight', headers: login_header(user), params: { date: '2020-02-10' })
          expect(status).to eq(200)
          expect(json['chart']).to eq(chart_data)
        end
      end

      context('一部の日付のデータしか存在しない場合') do
        it('チャートデータを返す') do
          (1..5).each do |n|
            day = create(:day, user: user, date: Date.new(2020, 2, n))
            create(:body, day: day, weight: n)
          end

          chart_data = (1..10).map do |n|
            n > 5 ? 0 : "#{n}.0"
          end
          get('/api/v1/charts/date_weight', headers: login_header(user), params: { date: '2020-02-10' })
          expect(json['chart']).to eq(chart_data)
        end
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/date_weight')
        expect(status).to eq(401)
      end
    end
  end

  describe('GET /api/v1/charts/date_percentage') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      it('チャートデータを返す') do
        (1..5).each do |n|
          day = create(:day, date: Date.new(2020, 2, n), user: user)
          create(:body, day: day, percentage: n)
        end

        chart_data = (1..10).map do |n|
          n > 5 ? 0 : "#{n}.0"
        end
        get('/api/v1/charts/date_percentage', headers: login_header(user), params: { date: '2020-02-10' })
        expect(json['chart']).to eq(chart_data)
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/date_percentage')
        expect(status).to eq(401)
      end
    end
  end
end
