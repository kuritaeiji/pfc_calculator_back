class AteFoodSerializer < ActiveModel::Serializer
  attributes(:id, :amount, :title, :calory, :protein, :fat, :carbonhydrate)

  belongs_to(:day)
  belongs_to(:food)
end
