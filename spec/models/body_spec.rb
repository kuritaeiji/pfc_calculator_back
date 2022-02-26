require 'rails_helper'

RSpec.describe Body, type: :model do
  it { is_expected.to belong_to(:day) }
end
