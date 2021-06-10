# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::MyFees do
  it "returns amount fees" do
    VCR.use_cassette "amz/my_fees" do
      asin = "B005HE1OMW"
      price = 20.0
      amount_fees = 6.64
      task = build(:task)
      params = task.api_keys.merge(marketplace: marketplace_us)

      expect(described_class.new(params).estimate(asin: asin, price: price).amount).to eq amount_fees
    end
  end

  def marketplace_us
    Peddler::Marketplace.find("US").id
  end
end
