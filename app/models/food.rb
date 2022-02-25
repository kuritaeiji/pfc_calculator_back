class Food < ApplicationRecord
  belongs_to(:category)

  validates(:title, presence: true, length: { maximum: 20 })
  validates(:per, presence: true)
  validates(:unit, presence: true, length: { maximum: 10 })
  # decimal型は小数点三桁以上の数値を与えると勝手に小数点二桁に四捨五入される
  # nilはnullとなるのでprecence: trueは必須
  # precisionはよしなにしてくれないため10桁以内か確認する
  validates(:calory, decimal: true)
  validates(:protein, decimal: true)
  validates(:fat, decimal: true)
  validates(:carbonhydrate, decimal: true)

  default_scope { order(:id) }
end
