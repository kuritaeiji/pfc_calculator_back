class AteFoodSerializer < ActiveModel::Serializer
  attributes(:id, :amount)

  belongs_to(:day)
  belongs_to(:food)

  class << self
    def define_original_attributes(*attr_names)
      attr_names.each do |attr_name|
        attribute(attr_name)
        define_method(attr_name) { object.send(attr_name) }
      end
    end
  end

  define_original_attributes(:calory, :protein, :fat, :carbonhydrate)
end
