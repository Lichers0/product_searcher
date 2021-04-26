# frozen_string_literal: true

module Service
  class AmazonApi
    delegate :credentials, to: :'Rails.application'

    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
    end

    def product_search(upc:, cost:)
      client = MWS::Products::Client.new(reports_params)
      response = client.get_matching_product_for_id(marketplace, "UPC", upc)
      binding.pry
    end

    def validate
      client = MWS::Reports::Client.new(reports_params)
      client.get_report_count(report_type_list: "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_")
      @valid = true
    rescue Peddler::Errors::Error
      @valid = false
    end

    # private

    attr_reader :seller_id, :mws_auth_token

    def marketplace
      "ATVPDKIKX0DER"
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
end
