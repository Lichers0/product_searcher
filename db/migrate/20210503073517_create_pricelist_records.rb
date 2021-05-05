# frozen_string_literal: true

class CreatePricelistRecord < ActiveRecord::Migration[6.1]
  def change
    create_table pricelist_records do |t|
      t.references :task, null: false, foreign_key: true
      t.string :upc
      t.decimal :cost, precision: 8, scale: 2
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
