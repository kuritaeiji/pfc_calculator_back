require 'rails_helper'

RSpec.describe Day, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:body).dependent(:destroy) }
  it { is_expected.to have_many(:ate_foods).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:date) }

  it('ユーザーが同じ日付を複数持つとバリデーションエラー') do
    user = create(:user)
    date = '2022-01-01'
    create(:day, date: date, user: user)
    day = build(:day, date: date, user: user)
    day.valid?

    expect(day.errors.messages[:date]).to include(I18n.t('errors.messages.taken'))
  end
end
