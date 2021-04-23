# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :price_columns_presence, :amazon_user_api_keys

  private

  def amazon_user_api_keys
    errors.add(:wrong_keys, "amazon keys errors") if AmazonUserApiKeys.new(seller_id, mws_auth_token).invalid?
  end

  def price_columns_presence
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    binding.pry
    errors.add(:wrong_csv_header, "don't find columns") if Price.new(temp_file).import_columns_presence?
  end
end
