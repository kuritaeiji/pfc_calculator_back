class CreateFoods < ActiveRecord::Migration[6.0]
  include(DecimalMigration)

  def change
    create_table :foods do |t|
      t.string(:title, null: false)
      t.integer(:per, null: false)
      t.string(:unit, null: false)
      t.decimal(:calory, decimal_options)
      t.decimal(:protein, decimal_options)
      t.decimal(:fat, decimal_options)
      t.decimal(:carbonhydrate, decimal_options)
      t.references(:category, foreign_key: true)
      t.timestamps
    end
  end
end
