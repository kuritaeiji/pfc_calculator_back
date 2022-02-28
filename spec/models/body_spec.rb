require 'rails_helper'

RSpec.describe Body, type: :model do
  it { is_expected.to belong_to(:day) }

  it('外部キーday_idは一意') do
    day = create(:day)
    create(:body, day: day)
    body = build(:body, day: day)
    body.valid?

    expect(body.errors.messages[:day_id]).to include(I18n.t('errors.messages.taken'))
  end
end
