class Body < ApplicationRecord
  belongs_to(:day)

  validates(:weight, decimal: true)
  validates(:percentage, decimal: true)
  validates(:day_id, uniqueness: true)
end
