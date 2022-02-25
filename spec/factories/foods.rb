FactoryBot.define do
  factory :food do
    title { 'フード' }
    per { 100 }
    unit { 'g' }
    calory { 100 }
    protein { 100 }
    fat { 100 }
    carbonhydrate { 100 }
    category
  end
end
