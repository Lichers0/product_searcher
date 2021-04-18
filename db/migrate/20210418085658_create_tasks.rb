# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :email
      t.string :seller_id
      t.string :mws_auth_token
      t.decimal :ship_to_fba, precision: 8, scale: 2
      t.decimal :services_cost, precision: 8, scale: 2

      t.timestamps
    end
  end
end
