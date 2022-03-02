require 'rails_helper'

RSpec.describe Day, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:body).dependent(:destroy) }
  it { is_expected.to have_many(:ate_foods).dependent(:destroy) }
  it { is_expected.to have_many(:dishes).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:date) }

  it('ユーザーが同じ日付を複数持つとバリデーションエラー') do
    user = create(:user)
    date = '2022-01-01'
    create(:day, date: date, user: user)
    day = build(:day, date: date, user: user)
    day.valid?

    expect(day.errors.messages[:date]).to include(I18n.t('errors.messages.taken'))
  end

  describe('calory, protein, fat, carbonhydrate method') do
    let(:day) { create(:day) }
    let(:food1) { create(:food, calory: 100, protein: 100, fat: 100, carbonhydrate: 100, per: 100) }
    let(:food2) { create(:food, calory: 200, protein: 200, fat: 200, carbonhydrate: 200, per: 100) }
    let!(:ate_food1) { create(:ate_food, day: day, food: food1, amount: 100) }
    let!(:ate_food2) { create(:ate_food, day: day, food: food2, amount: 200) }
    let!(:dish1) { create(:dish, calory: 100, protein: 100, fat: 100, carbonhydrate: 100, day: day) }
    let!(:dish2) { create(:dish, calory: 200, protein: 200, fat: 200, carbonhydrate: 200, day: day) }

    it('calory') do
      expect(day.calory).to eq(800.0)
    end

    it('protein') do
      expect(day.protein).to eq(800.0)
    end

    it('fat') do
      expect(day.fat).to eq(800.0)
    end

    it('carbonhydrate') do
      expect(day.carbonhydrate).to eq(800.0)
    end
  end
end
