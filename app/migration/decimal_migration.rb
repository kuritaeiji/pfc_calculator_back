module DecimalMigration
  def decimal_options
    { null: false, default: 0, precision: 10, scale: 2 }
  end
end
