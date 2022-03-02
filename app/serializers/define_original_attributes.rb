module DefineOriginalAttributes
  def define_original_attributes(*attr_names)
    attr_names.each do |attr_name|
      attribute(attr_name)
      define_method(attr_name) { object.send(attr_name) }
    end
  end
end
