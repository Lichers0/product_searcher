# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :email, null: false
      t.string :seller_id, null: false
      t.string :mws_auth_token, null: false
      t.decimal :ship_to_fba, precision: 8, scale: 2, null: false
      t.decimal :services_cost, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
