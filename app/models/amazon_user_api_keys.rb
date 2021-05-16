# frozen_string_literal: true

class AmazonUserApiKeys
  delegate :credentials, to: :'Rails.application'

  def initialize(seller_id:, mws_auth_token:)
    @seller_id = seller_id
    @mws_auth_token = mws_auth_token
  end

  def valid?
    return false unless keys_present?
    return @valid if defined? @valid

    @valid = validate
  end

  def invalid?
    !valid?
  end

  private

  attr_reader :seller_id, :mws_auth_token

  def keys_present?
    seller_id.presence && mws_auth_token.presence
  end

  def validate
    client = MWS::Reports::Client.new(reports_params)
    client.get_report_count
    true
  rescue Peddler::Errors::Error
    false
  end

  def reports_params
    {
      marketplace: "US",
      merchant_id: seller_id,
      aws_access_key_id: credentials.mws[:aws_access_key_id],
      aws_secret_access_key: credentials.mws[:aws_secret_access_key],
      auth_token: mws_auth_token
    }
  end
end
