require 'rails_helper'

RSpec.describe Food, type: :model do
  it { is_expected.to belong_to(:category) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(20) }
  it { is_expected.to validate_presence_of(:per) }
  it { is_expected.to validate_presence_of(:unit) }
  it { is_expected.to validate_length_of(:unit).is_at_most(10) }

  describe('decimal validation') do
    it('有効な値の場合エラーは発生しない') do
      food = build(:food)
      expect(food.valid?).to eq(true)
    end

    it('nilの場合エラー') do
      food = build(:food, calory: nil)
      food.valid?
      expect(food.errors.messages[:calory]).to include(I18n.t('errors.messages.blank'))
    end

    it('10桁より大きいと場合エラー') do
      food = build(:food, calory: 12345678901)
      food.valid?
      expect(food.errors.messages[:calory]).to include(I18n.t('errors.messages.precision', precision: 10))
    end
  end

  it('default_scope') do
    expect(Food.all.to_sql).to eq(Food.all.order(:id).to_sql)
  end

  it { is_expected.to delegate_method(:user).to(:category) }
end
