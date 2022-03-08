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

  describe('GET /api/v1/cahrats/month_weight') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      it('月ごとの平均体重を返す') do
        month = Date.new(2020, 10, 1)
        5.times do |n|
          date = month.ago(n.month)
          5.times do |num|
            day = create(:day, user: user, date: date.since(num.day))
            create(:body, day: day, weight: num * 10)
          end
        end

        chart_data = [].fill(0, 0, 5) + [].fill('20.0', 0, 5)

        get('/api/v1/charts/month_weight', headers: login_header(user), params: { month: '2020-10' })
        expect(json['chart']).to eq(chart_data)
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/month_weight')
        expect(status).to eq(401)
      end
    end
  end

  describe('GET /api/v1/charts/month_percentage') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      it('月ごとの平均体脂肪率を返す') do
        date = Date.new(2020, 1, 1)
        5.times do |n|
          month_date = date.since(n.month)
          5.times do |number|
            day_date = month_date.since(number.day)
            day = create(:day, user: user, date: day_date)
            create(:body, day: day, percentage: number)
          end
        end

        get('/api/v1/charts/month_percentage', headers: login_header(user), params: { month: '2020-10' })
        expect(json['chart']).to eq([].fill('2.0', 0, 5) + [].fill(0, 0, 5))
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/month_percentage')
        expect(status).to eq(401)
      end
    end
  end

  describe('GET /api/v1/charts/date_calory') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      it('日付毎のカロリーの合計値を返す') do
        date = Date.new(2020, 1, 1)
        day1 = create(:day, user: user, date: date)
        create(:dish, day: day1, calory: 200)
        create(:dish, day: day1, calory: 300)
        create(:day, user: user, date: date.ago(1.day))

        get('/api/v1/charts/date_calory', headers: login_header(user), params: { date: '2020-01-01' })
        expect(status).to eq(200)
        expect(json['chart']).to eq([].fill(0, 0, 8) + ['0.0'] + ['500.0'])
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/date_calory')
        expect(status).to eq(401)
      end
    end
  end

  describe('GET /api/v1/charts/month_calory') do
    context('ログインしている場合') do
      let(:user) { create(:user) }

      it('月ごとの平均カロリーを返す') do
        date = Date.new(2020, 1, 1)
        5.times do |n|
          month_date = date.since(n.month)
          5.times do |number|
            day = create(:day, user: user, date: month_date.since(number.day))
            create(:dish, day: day, calory: number * 100)
          end
        end

        get('/api/v1/charts/month_calory', headers: login_header(user), params: { month: '2020-10' })
        expect(json['chart']).to eq([].fill('200.0', 0, 5) + [].fill(0, 0, 5))
      end
    end

    context('ログインしていない場合') do
      it('401レスポンスを返す') do
        get('/api/v1/charts/month_calory')
        expect(status).to eq(401)
      end
    end
  end
end
