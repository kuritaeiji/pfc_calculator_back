FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'Password1010' }
    password_confirmation { 'Password1010' }
    activated { true }

    trait('with_categories') do
      after(:build) do |user|
        3.times { user.categories << FactoryBot.build(:category) }
      end
    end

    trait('with_foods') do
      after(:build) do |user|
        3.times do
          category = FactoryBot.build(:category)
          user.categories << category
          3.times do
            category.foods << FactoryBot.build(:food)
          end
        end
      end
    end
  end
end
