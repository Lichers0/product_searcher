# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::CompetitivePricing do
  describe "#product_price" do
    it "returns price product" do
      VCR.use_cassette "amz/competitive_pricing" do
        asin = "B00BUFXI6M"
        product_price = 4.65

        result = described_class.new(api_keys_and_marketplace).for_asin(asin: asin)

        expect(result.product_price).to eq product_price
      end
    end
  end

  describe "#offers_count" do
    it "returns total offer quantity" do
      VCR.use_cassette "amz/competitive_pricing" do
        asin = "B00BUFXI6M"
        total_offers_count = 8

        result = described_class.new(api_keys_and_marketplace).for_asin(asin: asin)

        expect(result.offers_count).to eq total_offers_count
      end
    end
  end
end
