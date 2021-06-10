# frozen_string_literal: true

class ProductPairIncome
  def initialize(params)
    @listing_price = params[:listing_price]
    @amount = params[:amount]
    @quantity = params[:quantity]
    @cost = params[:cost]
    @services_cost = params[:services_cost]
    @weight = params[:weight]
    @ship_to_fba = params[:ship_to_fba]
  end

  def amount
    @amount ||= listing_price - amount_fees - quantity * cost - services_cost - weight * ship_to_fba
  end

  private

  attr_reader :listing_price, :amount_fees, :quantity, :cost, :services_cost, :weight, :ship_to_fba
end
