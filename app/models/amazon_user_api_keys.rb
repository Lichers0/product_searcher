# frozen_string_literal: true

class AmazonUserApiKeys
  delegate :credentials, to: :'Rails.application'

  def initialize(seller_id:, mws_auth_token:)
    @seller_id = seller_id
    @mws_auth_token = mws_auth_token
  end

  def valid?
    @valid ||= validate
  end

  def invalid?
    !valid?
  end

  private

  attr_reader :seller_id, :mws_auth_token

  def validate
    client = MWS::Reports::Client.new(reports_params)
    client.get_report_count(report_type_list: "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_")
  rescue Peddler::Errors::Error
    @valid = false
  end

  def reports_params
    {
      marketplace: "US",
      merchant_id: "#{seller_id}1",
      aws_access_key_id: credentials.mws[:aws_access_key_id],
      aws_secret_access_key: credentials.mws[:aws_secret_access_key],
      auth_token: mws_auth_token
    }
  end
end
