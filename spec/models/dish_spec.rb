require 'rails_helper'

RSpec.describe Dish, type: :model do
  it { is_expected.to belong_to(:day) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(20) }

  it('default_scope') do
    expect(Dish.all.to_sql).to eq(Dish.all.order(:id).to_sql)
  end
end
