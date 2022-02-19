class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return record.errors.add(attribute, :blank) unless value.present?

    regexp = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    record.errors.add(attribute, :invalid) unless value.match?(regexp)

    record.errors.add(attribute, :taken) if record.other_activated_user?

    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max
  end
end
