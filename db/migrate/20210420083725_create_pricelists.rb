class CreatePricelists < ActiveRecord::Migration[6.1]
  def change
    create_table :pricelists do |t|
      t.references :task, null: false, foreign_key: true
      t.string :upc
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps
    end
  end
end
