# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::CompetitivePricing do
  it "returns price product" do
    VCR.use_cassette "amz/competitive_pricing" do
      asin = "B00BUFXI6M"
      price_product = 4.65
      task = build(:task)
      params = task.api_keys.merge(marketplace: marketplace_us)

      result = described_class.new(params).for_asin(asin: asin)

      expect(result.landed_price).to eq price_product
    end
  end

  it "returns offers count product" do
    VCR.use_cassette "amz/competitive_pricing" do
      asin = "B00BUFXI6M"
      offers_count = 8
      task = build(:task)
      params = task.api_keys.merge(marketplace: marketplace_us)

      result = described_class.new(params).for_asin(asin: asin)

      expect(result.offers_count).to eq offers_count
    end
  end

  def marketplace_us
    Peddler::Marketplace.find("US").id
  end
end
