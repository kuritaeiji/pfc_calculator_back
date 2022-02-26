class DecimalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return record.errors.add(attribute, :blank) unless value

    precision = 10
    num_string = value.to_s.split('.').join
    record.errors.add(attribute, :precision, precision: precision) if num_string.length > precision
  end
end
