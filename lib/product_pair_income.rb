# frozen_string_literal: true

class ProductPairIncome
  def amount
    @amount ||= listing_price - amount_fees - quantity * cost - services_cost - weight * ship_to_fba
  end

  attr_accessor :listing_price, :amount_fees, :quantity, :cost, :services_cost, :weight, :ship_to_fba
end
