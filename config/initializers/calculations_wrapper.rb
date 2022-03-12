module CalculationsWrapper
  def calculate(operation, column_name)
    if not_calory_and_pfc_column_but_attr_method?(column_name)
      return 0 unless present?

      return to_a.send(operation, &column_name) if operation == :sum
      return (sum(column_name) / count).round(2) if operation == :average
    end

    super
  end

  def not_calory_and_pfc_column_but_attr_method?(column_name)
    attr_names.include?(column_name) &&
      !klass.has_attribute?(column_name) && klass.public_instance_methods.include?(column_name)
  end

  def attr_names
    [:calory, :protein, :fat, :carbonhydrate]
  end

  def klass
    self.class.to_s.split('::')[0].constantize
  end
end

ActiveRecord::Calculations.prepend(CalculationsWrapper)
