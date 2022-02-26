class Category < ApplicationRecord
  belongs_to(:user)
  has_many(:foods, dependent: :destroy)

  validates(:title, presence: true, length: { maximum: 20 })

  default_scope { order(:id) }
end
