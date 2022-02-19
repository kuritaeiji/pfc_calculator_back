class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 空白でないこと、文字数は72文字以下であること、password_confirmationと値を比較し、同じであることはすでに確認済み
    return unless value.present?

    min = 8
    record.errors.add(attribute, :too_short, count: min) if value.length < min

    regexp = /(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[\w-]+/
    record.errors.add(attribute, :password) unless value.match?(regexp)
  end
end
