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

  it "returns offers count product" do
    VCR.use_cassette "amz/competitive_pricing" do
      asin = "B00BUFXI6M"
      offers_count = 8

      result = described_class.new(api_keys_and_marketplace).for_asin(asin: asin)

      expect(result.offers_count).to eq offers_count
    end
  end

  def api_keys_and_marketplace
    attributes_for(:task)
      .slice(:seller_id, :mws_auth_token)
      .merge(marketplace: marketplace_us)
  end

  def marketplace_us
    Peddler::Marketplace.find("US").id
  end
end
