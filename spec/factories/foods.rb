FactoryBot.define do
  factory :food do
    sequence(:title) { |n| "フード#{n}" }
    per { 100 }
    unit { 'g' }
    calory { 100 }
    protein { 100 }
    fat { 100 }
    carbonhydrate { 100 }
    category
  end
end
