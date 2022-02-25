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
    3.times do |number|
      category.foods.create!(title: "鶏胸肉#{number}", per: 100, unit: 'g',
                             calory: 120, protein: 23.45, fat: 0.1, carbonhydrate: 0.23)
    end
  end
end
