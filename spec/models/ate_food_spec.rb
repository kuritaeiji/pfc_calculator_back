require 'rails_helper'

RSpec.describe AteFood, type: :model do
  it { is_expected.to belong_to(:day) }
  it { is_expected.to belong_to(:food) }

  describe('[calory, protein, fat, carbonhydrate]method') do
    let(:food) { build(:food, per: 100, calory: 100.55, protein: 100.5, fat: 100, carbonhydrate: 0) }
    let(:ate_food) { build(:ate_food, amount: 10, food: food) }

    it('calory') do
      expect(ate_food.calory).to eq(10.06)
    end

    it('protein') do
      expect(ate_food.protein).to eq(10.05)
    end

    it('fat') do
      expect(ate_food.fat).to eq(10)
    end

    it('carbonhydrate') do
      expect(ate_food.carbonhydrate).to eq(0)
    end
  end

  it('default_scope') do
    expect(AteFood.all.to_sql).to eq(AteFood.all.order(:id).to_sql)
  end
end
