10.times do |n|
  email = "user#{n}@example.com"
  password = 'Password1010'

  user = User.find_or_initialize_by(email: email)
  next unless user.new_record?

  user.password = password
  user.activated = true
  user.save!

  3.times do |num|
    user.categories.create!(title: "カテゴリー#{num}")
  end
end
