# frozen_string_literal: true

require "rails_helper"

RSpec.describe Amz::MyFees do
  it "returns fees amount" do
    VCR.use_cassette "amz/my_fees" do
      asin = "B005HE1OMW"
      price = 20.0
      amount_fees = 6.64

      my_fees = described_class.new(api_keys_and_marketplace)
      my_fees_estimate = my_fees.estimate(asin: asin, price: price)

      expect(my_fees_estimate.amount).to eq amount_fees
    end
  end
end
