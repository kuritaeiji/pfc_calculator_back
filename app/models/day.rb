class Day < ApplicationRecord
  belongs_to(:user)
  has_one(:body, dependent: :destroy)
  has_many(:ate_foods, dependent: :destroy)

  validates(:date, presence: true, uniqueness: { scope: :user })
end
