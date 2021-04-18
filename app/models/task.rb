# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
end
