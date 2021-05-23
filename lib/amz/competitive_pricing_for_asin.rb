# frozen_string_literal: true

module Amz
  class CompetitivePricingForAsin < Amz::ApiService
    def call(marketplace:, asin:)
      @response = client.get_competitive_pricing_for_asin(marketplace, asin)

      self
    end

    def landed_price
      return @landed_price if defined? @landed_price

      @landed_price ||= landed_price_amount
    end

    def offers_count
      return offers_count_new_condition if offering_listing.is_a?(Array)

      offering_listing&.fetch("Amount").to_i
    end

    alias total_offers offers_count
    alias listing_price landed_price

    private

    def competitive_pricing
      @competitive_pricing ||= response.dig("Product", "CompetitivePricing")
    end

    def conditions_prices
      @conditions_prices ||= competitive_pricing&.dig("CompetitivePrices", "CompetitivePrice")
    end

    def landed_price_with_new_condition
      return conditions_prices unless conditions_prices.is_a?(Array)

      conditions_prices.find { |record| record["condition"].casecmp?("new") }
    end

    def landed_price_amount
      landed_price_with_new_condition&.dig("Price", "LandedPrice", "Amount").to_d || 0
    end

    def offering_listing
      @offering_listing ||= competitive_pricing&.dig("NumberOfOfferListings", "OfferListingCount")
    end

    def offers_count_new_condition
      offering_listing
        .find { |record| record["condition"].casecmp?("new") }
        .fetch("__content__")
    end
  end
end
