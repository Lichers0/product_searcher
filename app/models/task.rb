# frozen_string_literal: true

class Task < ApplicationRecord
  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
end
