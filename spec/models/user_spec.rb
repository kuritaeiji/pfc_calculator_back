require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:categories).dependent(:destroy) }
  it { is_expected.to have_many(:days).dependent(:destroy) }

  it { is_expected.to have_secure_password }

  describe('email validation') do
    it('email is empty') do
      user = build(:user, email: '')
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.blank'))
      expect(user.errors.messages[:email].length).to eq(1)
    end

    it('email is invalid format') do
      user = build(:user, email: 'abcd@abcd')
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.invalid'))
    end

    describe('email is unique in activated users') do
      let(:email) { 'user@example.com' }
      context('すでに同じメアドでアクティブなユーザーがいる時') do
        it('takenエラー') do
          create(:user, email: email)
          user = build(:user, email: email)
          user.valid?
          expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.taken'))
        end
      end

      context('同じメアドでアクティブでないユーザーがいる時') do
        it('エラーなし') do
          create(:user, email: email, activated: false)
          user = build(:user, email: email)
          expect(user.valid?).to eq(true)
        end
      end
    end

    it('email maximum is 255') do
      user = build(:user, email: 'a' * 266)
      user.valid?
      expect(user.errors.messages[:email]).to include(I18n.t('errors.messages.too_long', count: 255))
    end
  end

  describe('password validation') do
    it('password min length is 8') do
      user = build(:user, password: 'Passwo1')
      user.valid?
      expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.too_short', count: 8))
    end

    describe('password format') do
      it('パスワードが三種類含んでないとき') do
        user = build(:user, password: 'Password')
        user.valid?
        expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.password'))
      end

      it('パスワードにハイフンアンダーバー以外が使われるとき') do
        user = build(:user, password: 'Password.')
        user.valid?
        expect(user.errors.messages[:password]).to include(I18n.t('errors.messages.password'))
      end
    end
  end

  describe('other_activated_user?') do
    let(:email) { 'user@example.com' }

    context('他にユーザーがいない場合') do
      it('falseを返す') do
        create(:user, email: email, activated: false)
        user = build(:user, email: email)
        expect(user.other_activated_user?).to eq(false)
      end
    end

    context('他にユーザーがいる場合') do
      it('trueを返す') do
        create(:user, email: email, activated: true)
        user = build(:user, email: email)
        expect(user.other_activated_user?).to eq(true)
      end
    end
  end

  describe('foods') do
    it('ユーザーが所持しているfoodsを取得する') do
      user = create(:user, :with_foods)
      expect(user.foods.count).to eq(9)
      expect(user.foods[0].title).to include('フード')
    end
  end

  describe('bodies') do
    it('ユーザーが所有しているbodiesを取得する') do
      user = create(:user, :with_bodies)
      bodies = user.bodies
      expect(bodies.length).to eq(3)
      expect(bodies[0].respond_to?(:weight)).to eq(true)
    end
  end

  describe('ate_foods') do
    it('ユーザーが所有しているate_foodsを取得する') do
      user = create(:user)
      day = create(:day, user: user)
      create_list(:ate_food, 3, day: day)
      ate_foods = user.ate_foods

      expect(ate_foods.length).to eq(3)
      expect(ate_foods[0].respond_to?(:amount)).to eq(true)
    end
  end

  describe('find_from_token_class_method') do
    let(:user) { create(:user) }

    context('不正なトークンの場合') do
      it('JWT::DecodeErrorが発生する') do
        token = "#{AuthToken.create_token(sub: user.id)}hoge"
        expect { User.find_from_token(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context('ユーザーが見つからない場合') do
      it('ActiveRecord::RecordNotFoundエラーが発生する') do
        token = AuthToken.create_token(sub: 0)
        expect { User.find_from_token(token) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context('正しいトークンでユーザーが見つかる場合') do
      it('ユーザーを返す') do
        token = user.create_token
        expect(User.find_from_token(token)).to eq(user)
      end
    end
  end

  describe('average_month_weight') do
    it('ある月の平均体重を返す') do
      user = create(:user)
      day1 = create(:day, user: user, date: '2020-01-01')
      day2 = create(:day, user: user, date: '2020-01-02')
      create(:day, user: user, date: '2020-01-03')
      create(:body, day: day1, weight: 50)
      create(:body, day: day2, weight: 40)

      expect(user.average_month_weight(2020, 1)).to eq(45)
    end

    it('bodyが存在しない時0を返す') do
      user = create(:user)
      create(:day, user: user, date: '2020-01-01')
      create(:day, user: user, date: '2020-01-02')

      expect(user.average_month_weight(2020, 1)).to eq(0)
    end
  end

  describe('average_month_percentage') do
    it('ある月の平均体脂肪率を返す') do
      user = create(:user)
      day1 = create(:day, user: user, date: '2020-01-01')
      day2 = create(:day, user: user, date: '2020-01-02')
      create(:day, user: user, date: '2020-01-03')
      create(:body, day: day1, percentage: 30)
      create(:body, day: day2, percentage: 20)

      expect(user.average_month_percentage(2020, 1)).to eq(25)
    end

    it('bodyが存在しない時0を返す') do
      user = create(:user)
      create(:day, user: user, date: '2020-01-01')
      create(:day, user: user, date: '2020-01-02')

      expect(user.average_month_percentage(2020, 1)).to eq(0)
    end
  end

  describe('average_month_calory_and_pfc') do
    let(:user) { create(:user) }

    context('ユーザーがある月のdayオブジェクトを所持している場合') do
      it('カロリーを返す') do
        date = Date.new(2020, 1, 1)
        day1 = create(:day, date: date, user: user)
        day2 = create(:day, date: date.since(1.day), user: user)
        create(:dish, day: day1, calory: 100.13)
        create(:dish, day: day2, calory: 100.12)

        not_day = create(:day, date: date.since(1.month), user: user)
        create(:dish, day: not_day)

        expect(user.average_month_calory(date.year, date.month)).to eq(100.13)
      end
    end

    context('ユーザーがある月のdayオブジェクトを所持していない場合') do
      it('0を返す') do
        expect(user.average_month_calory(2020, 1)).to eq(0)
      end
    end
  end

  describe('create_token') do
    it('トークンを返す') do
      Timecop.freeze(Time.now)
      user = create(:user)
      token = user.create_token
      payload = AuthToken.decode(token: token)

      expect(payload[:sub]).to eq(user.id)
      expect(payload[:exp]).to eq(AuthToken.default_lifetime.from_now.to_i)
    end
  end
end
