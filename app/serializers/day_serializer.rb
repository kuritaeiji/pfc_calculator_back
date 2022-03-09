class DaySerializer < ActiveModel::Serializer
  attributes(:id, :date, :calory, :protein, :fat, :carbonhydrate)
end
