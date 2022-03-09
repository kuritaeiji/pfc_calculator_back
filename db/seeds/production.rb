10.times do |n|
  email = "user#{n}@example.com"
  password = 'Password1010'

  user = User.find_or_initialize_by(email: email)
  next unless user.new_record?

  user.password = password
  user.activated = true
  user.save!

  3.times do |num|
    category = user.categories.create!(title: "カテゴリー#{num}")
    day = Day.create!(user: user, date: Date.today - num.day)
    Body.create!(weight: 50, percentage: 20, day: day)

    3.times do |number|
      food = category.foods.create!(
        title: "鶏胸肉#{number}",
        per: 100,
        unit: 'g',
        calory: 120,
        protein: 23.45,
        fat: 0.1,
        carbonhydrate: 0.23
      )
      day.ate_foods.create!(amount: 100, food: food)
      day.dishes.create!(title: "ラーメン#{number}", calory: 600, protein: 40, fat: 140, carbonhydrate: 300)
    end
  end
end
