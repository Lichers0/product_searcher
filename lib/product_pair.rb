# frozen_string_literal: true

class ProductPair
  MAX_BEST_SELLERS_RANK = 100_000
  MIN_PROFIT_FROM_SALE_OF_PRODUCT = 0.5

  def initialize(pricelist_record:, pair:)
    @pricelist_record = pricelist_record
    @pair = pair
  end

  def save_if_profitable
    return if bsr_invalid? || !profitable?

    save_profit_pair
  end

  private

  delegate :asin, :bsr, :quantity, :weight, :title, :brand, to: :pair
  delegate :total_offers, :listing_price, to: :competitive_pricing
  delegate :task, to: :pricelist_record
  delegate :ship_to_fba, :services_cost, :api_keys, to: :task
  delegate :cost, to: :pricelist_record
  delegate :amount_fees, to: :fees_by_current_asin

  attr_reader :pricelist_record, :pair

  def bsr_invalid?
    bsr > MAX_BEST_SELLERS_RANK || bsr.zero?
  end

  def profitable?
    income > MIN_PROFIT_FROM_SALE_OF_PRODUCT
  end

  def save_profit_pair
    ProfitPair.create(
      main_params.merge(offers_params).merge(pricelist_record: pricelist_record)
    )
  end

  def main_params
    {
      asin: asin,
      income: income,
      weight: weight,
      quantity_unit: quantity,
      buybox_price: listing_price,
      bsr: bsr,
      title: title,
      brand: brand
    }
  end

  def offers_params
    {
      total_offers: total_offers,
      fba_offers: 0
    }
  end

  def income
    @income ||= product_pair_income.amount
  end

  def product_pair_income
    ProductPairIncome.new(
      { listing_price: listing_price,
        amount_fees: amount_fees,
        quantity: quantity,
        cost: cost,
        services_cost: services_cost,
        weight: weight,
        ship_to_fba: ship_to_fba }
    )
  end

  def marketplace
    @marketplace ||= Peddler::Marketplace.find("US").id
  end

  def competitive_pricing
    @competitive_pricing ||= Amz::CompetitivePricing.new(api_keys.merge(marketplace: marketplace)).for_asin(asin: asin)
  end

  def fees_by_current_asin
    @fees_by_current_asin ||= Amz::MyFees.new(api_keys
      .merge(marketplace: marketplace)).estimate(asin: asin, price: listing_price)
  end
end
