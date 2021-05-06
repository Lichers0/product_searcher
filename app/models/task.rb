# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :price_columns_presence, :amazon_user_api_keys

  def api_keys
    {
      seller_id: seller_id,
      mws_auth_token: mws_auth_token
    }
  end

  private

  def amazon_user_api_keys
    return if keys_not_empty? && AmazonUserApiKeys.new(api_keys).valid?

    errors.add(:Wrong, "amazon api keys")
  end

  def keys_not_empty?
    !(seller_id.strip.empty? && mws_auth_token.strip.empty?)
  end

  def price_columns_presence
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    errors.add(:Csv, "required columns missing") unless Pricelist.new(temp_file).import_columns_present?
  end
end
