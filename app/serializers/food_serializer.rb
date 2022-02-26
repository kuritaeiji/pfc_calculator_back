class FoodSerializer < ActiveModel::Serializer
  attributes(:id, :title, :per, :unit, :calory, :protein, :fat, :carbonhydrate)

  belongs_to(:category)
end
