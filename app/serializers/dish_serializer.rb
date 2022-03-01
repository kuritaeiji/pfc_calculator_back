class DishSerializer < ActiveModel::Serializer
  attributes(:id, :title, :calory, :protein, :fat, :carbonhydrate)

  belongs_to(:day)
end
