require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(20) }
end
