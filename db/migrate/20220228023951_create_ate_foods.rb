class CreateAteFoods < ActiveRecord::Migration[6.0]
  include(DecimalMigration)

  def change
    create_table :ate_foods do |t|
      t.decimal(:amount, decimal_options)
      t.references(:day, foreign_key: true)
      t.references(:food, foreign_key: true)
      t.timestamps
    end
  end
end
