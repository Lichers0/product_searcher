# frozen_string_literal: true

class ApiChecker < ApplicationService
  def initialize(params)
    @seller_id = params[:seller_id]
    @mws_auth_token = params[:mws_auth_token]
    super()
  end

  def call
    client = MWS::Reports::Client.new(reports_params)

    client.get_report_count(
      report_type_list: "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_"
    )
    false
  rescue Peddler::Errors::Error => e
    e.response.parse["Code"]
  end

  private

  attr_reader :seller_id, :mws_auth_token

  def reports_params
    {
      marketplace: "US",
      merchant_id: "#{seller_id}1",
      aws_access_key_id: "AKIAIVHVPRCMH5UWD4HA",
      aws_secret_access_key: "c4S6Gzp5bCfReLUwmaSw79u8D62f4PUrkzRVqlQ01",
      auth_token: mws_auth_token
    }
  end
end
