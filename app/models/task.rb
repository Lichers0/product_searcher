# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :price_columns_presence, :amazon_user_api_keys

  private

  def amazon_user_api_keys
    return if AmazonUserApiKeys.new(seller_id: seller_id, mws_auth_token: mws_auth_token).valid?

    errors.add(:wrong_keys, "amazon keys errors")
  end

  def price_columns_presence
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    errors.add(:wrong_csv_header, "required columns missing") if Pricelist.new(temp_file).import_columns_present?
  end
end
