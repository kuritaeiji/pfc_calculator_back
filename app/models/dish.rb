class Dish < ApplicationRecord
  belongs_to(:day)

  validates(:title, presence: true, length: { maximum: 20 })
  validates(:calory, decimal: true)
  validates(:protein, decimal: true)
  validates(:fat, decimal: true)
  validates(:carbonhydrate, decimal: true)

  default_scope { order(:id) }
end
