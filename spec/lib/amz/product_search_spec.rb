# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::ProductSearch do
  it "gets all found products" do
    VCR.use_cassette "amz/product_search" do
      upc = "035585800158"
      asins_of_found_products = %w[B005HE1OMW B00HYER594 B0018N5328]
      task = build(:task)
      params = task.api_keys.merge(marketplace: marketplace_us)

      result = described_class.new(params).find_by(upc: upc)

      expect(result.map(&:asin)).to eq asins_of_found_products
    end
  end

  def marketplace_us
    Peddler::Marketplace.find("US").id
  end
end
