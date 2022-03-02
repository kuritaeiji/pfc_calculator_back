class AteFood < ApplicationRecord
  belongs_to(:food)
  belongs_to(:day)

  validates(:amount, decimal: true)

  default_scope { order(:id) }
  delegate(:title, to: :food)

  class << self
    def define_attrs(*attr_names)
      attr_names.each do |attr_name|
        define_method(attr_name) { calculate(attr_name) }
      end
    end
  end

  define_attrs(:calory, :protein, :fat, :carbonhydrate)

  private

  def calculate(attr_name)
    (food.send(attr_name) * amount / food.per).to_f.round(2)
  end
end
