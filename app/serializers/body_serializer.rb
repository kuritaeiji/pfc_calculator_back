class BodySerializer < ActiveModel::Serializer
  attributes(:id, :weight, :percentage)

  belongs_to(:day)
end
