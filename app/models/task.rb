# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :price_columns_presence, :amazon_user_api_keys

  def api_keys
    attributes
      .slice("seller_id", "mws_auth_token")
      .symbolize_keys
  end

  def pricelist_link
    @pricelist_link ||= ActiveStorage::Blob.service.path_for(file.key)
  end

  private

  def amazon_user_api_keys
    return if AmazonUserApiKeys.new(api_keys).valid?

    errors.add(:Wrong, "amazon api keys")
  end

  def price_columns_presence
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    errors.add(:Csv, "required columns missing") unless Pricelist.new(temp_file).import_columns_present?
  end
end
