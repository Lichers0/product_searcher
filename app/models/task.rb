# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  email          :string           not null
#  mws_auth_token :string           not null
#  services_cost  :decimal(8, 2)    not null
#  ship_to_fba    :decimal(8, 2)    not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  seller_id      :string           not null
#
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
