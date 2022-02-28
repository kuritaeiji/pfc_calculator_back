require 'rails_helper'

RSpec.describe AteFood, type: :model do
  it { is_expected.to belong_to(:day) }
  it { is_expected.to belong_to(:food) }
end
