require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(20) }

  it('default_scope') do
    expect(Category.all.to_sql).to eq(Category.all.order(:id).to_sql)
  end
end
