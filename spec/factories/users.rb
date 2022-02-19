FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'Password1010' }
    password_confirmation { 'Password1010' }
    activated { true }
  end
end
