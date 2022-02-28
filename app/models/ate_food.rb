class AteFood < ApplicationRecord
  belongs_to(:food)
  belongs_to(:day)

  validates(:amount, decimal: true)
end
