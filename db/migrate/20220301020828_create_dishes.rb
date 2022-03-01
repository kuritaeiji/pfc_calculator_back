class CreateDishes < ActiveRecord::Migration[6.0]
  include(DecimalMigration)

  def change
    create_table :dishes do |t|
      t.string(:title, null: false)
      t.decimal(:calory, decimal_options)
      t.decimal(:protein, decimal_options)
      t.decimal(:fat, decimal_options)
      t.decimal(:carbonhydrate, decimal_options)
      t.references(:day, foreign_key: true)
      t.timestamps
    end
  end
end
