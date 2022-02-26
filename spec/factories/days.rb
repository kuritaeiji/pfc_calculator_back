FactoryBot.define do
  factory :day do
    sequence(:date) do |n|
      "2022-01-0#{n}" if n < 10
      "2022-01-#{n}"
    end
    user
  end
end
