# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::CompetitivePricing do
  it "returns price product" do
    VCR.use_cassette "amz/competitive_pricing" do
      asin = "B00BUFXI6M"
      price_product = 4.65

      result = described_class.new(api_keys_and_marketplace).for_asin(asin: asin)

      expect(result.landed_price).to eq price_product
    end
  end

  it "returns total offer quantity" do
    VCR.use_cassette "amz/competitive_pricing" do
      asin = "B00BUFXI6M"
      total_offers_count = 8

      result = described_class.new(api_keys_and_marketplace).for_asin(asin: asin)

      expect(result.offers_count).to eq total_offers_count
    end
  end
end
