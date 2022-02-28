class CreateBodies < ActiveRecord::Migration[6.0]
  include(DecimalMigration)

  def change
    create_table :bodies do |t|
      t.decimal(:weight, decimal_options)
      t.decimal(:percentage, decimal_options)
      t.references(:day, foreign_key: true)
      t.timestamps
    end
  end
end
