# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :pricelists, dependent: :destroy
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :price_columns_presence, :amazon_user_api_keys

  private

  def amazon_user_api_keys
    return if Service::AmazonUserApiKeys.new(seller_id: seller_id, mws_auth_token: mws_auth_token).valid?

    errors.add(:wrong_keys, "amazon keys errors")
  end

  def price_columns_presence
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    return if Service::Pricelist.new(temp_file).import_columns_present?

    errors.add(:wrong_csv_header, "don't find columns")
  end
end
