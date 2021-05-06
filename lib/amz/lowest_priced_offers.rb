# frozen_string_literal: true

module Amz
  class LowestPricedOffers
    delegate :credentials, to: :'Rails.application'

    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
    end

    def call(marketplace:, asin:)
      client = MWS::Products::Client.new(reports_params)
      @response = client.get_lowest_priced_offers_for_asin(marketplace, asin, "NEW")
      self
    rescue Peddler::Errors::Error => e
      e
    end

    def buybox_price
      buybox_price_amount&.to_d || 0
    end

    def total_offer_count
      @response.dig("Summary", "TotalOfferCount") || 0
    end

    def fulfillment_amazon_count
      offer_count.find do |record|
        record["fulfillmentChannel"] == "Amazon" && record["condition"] == "new"
      end&.[]("__content__") || 0
    end

    private

    attr_reader :seller_id, :mws_auth_token

    def buybox_price_amount
      return buybox_new_condition if buybox.is_a?(Array)

      buybox&.dig("LandedPrice", "Amount")
    end

    def buybox_new_condition
      buybox.find do |record|
        record["condition"] == "new"
      end.dig("LandedPrice", "Amount")
    end

    def buybox
      @buybox ||= @response.dig("Summary", "BuyBoxPrices", "BuyBoxPrice")
    end

    def result_hash
      {
        total_offer_count: total_offer_count,
        fulfillment_amazon_count: fulfillment_amazon_count,
        fulfillment_merchant_count: fulfillment_merchant_count,
        buybox_price: buybox_price.to_f
      }
    end

    def offer_count
      result = @response.dig("Summary", "NumberOfOffers", "OfferCount")
      result.is_a?(Array) ? result : [result]
    end

    def fulfillment_merchant_count
      offer_count.find do |record|
        record["fulfillmentChannel"] == "Merchant" && record["condition"] == "new"
      end&.[]("__content__")
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
