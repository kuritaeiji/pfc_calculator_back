class Day < ApplicationRecord
  belongs_to(:user)

  validates(:date, presence: true, uniqueness: { scope: :user })
end
