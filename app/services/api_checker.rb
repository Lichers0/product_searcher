# frozen_string_literal: true

class ApiChecker < ApplicationService
  def initialize(task)
    @seller_id = task.seller_id
    @mws_auth_token = task.mws_auth_token
    super()
  end

  def call
    client = MWS::Reports::Client.new(reports_params)
    client.get_report_count(report_type_list: "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_")
    self.error = false
    self
  rescue Peddler::Errors::Error
    self.error = true
    self
  end

  def error?
    error
  end

  private

  attr_reader :seller_id, :mws_auth_token
  attr_accessor :error

  def reports_params
    {
      marketplace: "US",
      merchant_id: "#{seller_id}1",
      aws_access_key_id: Rails.application.credentials.mws[:aws_access_key_id],
      aws_secret_access_key: Rails.application.credentials.mws[:aws_secret_access_key],
      auth_token: mws_auth_token
    }
  end
end
