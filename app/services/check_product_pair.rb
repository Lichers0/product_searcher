# frozen_string_literal: true

class CheckProductPair < ApplicationService
  MAX_BEST_SELLERS_RANK = 100_000
  MIN_PROFIT_FROM_SALE_OF_PRODUCT = 0.5

  def initialize(pricelist_record:, pair:)
    @pricelist_record = pricelist_record
    @pair = pair
    super()
  end

  def call
    return if bsr > MAX_BEST_SELLERS_RANK || bsr.zero?

    @asin = pair[:asin]
    @quantity = pair[:package_quantity]
    @weight = pair[:weight]
    @title = pair[:title]
    @brand = pair[:brand]

    save_profit_pair if income > MIN_PROFIT_FROM_SALE_OF_PRODUCT
  end

  private

  delegate :task, to: :pricelist_record
  delegate :ship_to_fba, :services_cost, to: :task
  delegate :cost, to: :pricelist_record

  attr_reader :pricelist_record, :pair, :asin, :quantity, :weight, :title, :brand

  def bsr
    pair[:sales_rank]
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

  def total_offers
    competitive_pricing.offers_count
  end

  def listing_price
    @listing_price ||= competitive_pricing.landed_price
  end

  def income
    @income ||= listing_price - amount_fees - quantity * cost - services_cost - weight * ship_to_fba
  end

  def amount_fees
    @amount_fees ||= fees_by_current_asin.amount
  end

  def marketplace
    @marketplace ||= Peddler::Marketplace.find("US").id
  end

  def competitive_pricing
    @competitive_pricing ||= Amz::CompetitivePricingForAsin.new(api_keys).call(marketplace: marketplace, asin: asin)
  end

  def fees_by_current_asin
    @fees_by_current_asin ||=
      Amz::MyFeesEstimate.new(api_keys).call(marketplace: marketplace, asin: asin, price: listing_price)
  end

  def api_keys
    @api_keys ||= task.api_keys
  end
end
