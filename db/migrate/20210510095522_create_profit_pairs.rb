# frozen_string_literal: true

class CreateProfitPairs < ActiveRecord::Migration[6.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :profit_pairs do |t|
      t.string :asin
      t.decimal :income, precision: 8, scale: 2
      t.decimal :weight, precision: 8, scale: 2
      t.integer :quantity_unit
      t.integer :bsr
      t.integer :total_offers
      t.integer :fba_offers
      t.decimal :buybox_price, precision: 8, scale: 2
      t.string :title
      t.string :brand
      t.references :pricelist_record, null: false, foreign_key: true

      t.timestamps
    end
  end
end
