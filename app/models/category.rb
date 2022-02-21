class Category < ApplicationRecord
  belongs_to(:user)

  validates(:title, presence: true, length: { maximum: 20 })
end
