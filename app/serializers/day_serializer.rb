class DaySerializer < ActiveModel::Serializer
  attributes(:id, :date)

  extend(DefineOriginalAttributes)
  define_original_attributes(:calory, :protein, :fat, :carbonhydrate)
end
