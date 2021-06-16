# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductPairIncome do
  describe "#amount" do
    it "returns listing price minus fees, product cost, services and shipping" do
      listing_price = 20.0.to_d
      amount_fees = 6.2.to_d
      quantity = 1
      cost = 1.2.to_d
      services_cost = 0.5.to_d
      weight = 1.5.to_d
      ship_to_fba = 0.3.to_d

      income = described_class.new(
        listing_price: listing_price,
        amount_fees: amount_fees,
        quantity: quantity,
        cost: cost,
        services_cost: services_cost,
        weight: weight,
        ship_to_fba: ship_to_fba
      )

      expect(income.amount)
        .to eq listing_price - (amount_fees + (quantity * cost) + services_cost + (weight * ship_to_fba))
    end
  end
end
