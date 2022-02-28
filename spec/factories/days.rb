FactoryBot.define do
  factory :day do
    sequence(:date) { |n| Date.today - n.day }
    user
  end
end
