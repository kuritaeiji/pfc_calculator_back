class CreateBodies < ActiveRecord::Migration[6.0]
  def change
    create_table :bodies do |t|
      t.decimal(:weight, decimal_options)
      t.decimal(:percentage, decimal_options)
      t.references(:day, foreign_key: true)
      t.timestamps
    end
  end

  private

  def decimal_options
    { null: false, default: 0, precision: 10, scale: 2 }
  end
end
