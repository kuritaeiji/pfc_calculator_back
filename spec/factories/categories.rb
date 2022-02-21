FactoryBot.define do
  factory :category do
    sequence(:title) { |n| "カテゴリー#{n}" }
    user
  end
end
