# frozen_string_literal: true

class ProductPairIncome
  def initialize(listing_price:, amount_fees:, quantity:, cost:, services_cost:, weight:, ship_to_fba:) # rubocop:disable Metrics/ParameterLists
    @listing_price = listing_price
    @amount_fees = amount_fees
    @quantity = quantity
    @cost = cost
    @services_cost = services_cost
    @weight = weight
    @ship_to_fba = ship_to_fba
  end

  def amount
    @amount ||= listing_price - amount_fees - quantity * cost - services_cost - weight * ship_to_fba
  end

  private

  attr_reader :listing_price, :amount_fees, :quantity, :cost, :services_cost, :weight, :ship_to_fba
end
