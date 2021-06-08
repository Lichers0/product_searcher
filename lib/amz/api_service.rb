# frozen_string_literal: true

module Amz
  class ApiService
    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
      @api_client = MWS::Products::Client.new(reports_params)
    end

    private

    attr_reader :seller_id, :mws_auth_token, :api_client
    attr_accessor :response

    delegate :credentials, to: :'Rails.application'

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
end
