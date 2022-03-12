class Day < ApplicationRecord
  belongs_to(:user)
  has_one(:body, dependent: :destroy)
  has_many(:ate_foods, dependent: :destroy)
  has_many(:dishes, dependent: :destroy)

  validates(:date, presence: true, uniqueness: { scope: :user })

  class << self
    def define_attrs(*attr_names)
      attr_names.each do |attr_name|
        # ate_foodsはcaloryカラムを持っていないが、sumメソッドをCalculationsWrapperでハックしたため使える
        define_method(attr_name) { ate_foods.eager_load(:food).sum(attr_name) + dishes.sum(attr_name) }
      end
    end
  end

  define_attrs(:calory, :protein, :fat, :carbonhydrate)
end
