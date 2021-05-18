# frozen_string_literal: true

module Amz
  class CompetitivePricingForAsin
    delegate :credentials, to: :'Rails.application'

    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
    end

    def call(marketplace:, asin:)
      client = MWS::Products::Client.new(reports_params)
      @response = client.get_competitive_pricing_for_asin(marketplace, asin)
    end

    def landed_price
      return @landed_price if defined? @landed_price

      conditions_prices = competitive_pricing&.dig("CompetitivePrices", "CompetitivePrice")

      @landed_price ||= landed_price_with_new_condition(conditions_prices)&.dig("Price", "LandedPrice", "Amount").to_d || 0
    end

    def offers_count
      return offers_count_new_condition if offering_listing.is_a?(Array)

      offering_listing&.[]("Amount").to_i
    end

    private

    attr_reader :seller_id, :mws_auth_token

    def landed_price_with_new_condition(conditions_prices)
      return conditions_prices unless conditions_prices.is_a?(Array)

      conditions_prices.find do |record|
        record["condition"].casecmp?("new")
      end
    end

    def competitive_pricing
      @competitive_pricing ||= @response.dig("Product", "CompetitivePricing")
    end

    def offering_listing
      @offering_listing ||= competitive_pricing&.dig("NumberOfOfferListings", "OfferListingCount")
    end

    def offers_count_new_condition
      offering_listing.find do |record|
        record["condition"].casecmp?("new")
      end["__content__"]
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
