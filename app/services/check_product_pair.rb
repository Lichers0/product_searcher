# frozen_string_literal: true

class CheckProductPair < ApplicationService
  def initialize(pricelist_record:, pair:)
    @pricelist_record = pricelist_record
    @pair = pair
    super()
  end

  def call
    @bsr = pair[:sales_rank]
    return if bsr > 100_000 || bsr.zero?

    init_pair_variable
    save_profit_pair if income > 0.5
  end

  private

  attr_reader :pricelist_record, :pair, :asin, :quantity, :weight, :bsr, :title, :brand

  def save_profit_pair
    ProfitPair.create(pricelist_record: pricelist_record,
                      asin: asin,
                      income: income,
                      weight: weight,
                      quantity_unit: quantity,
                      buybox_price: listing_price,
                      bsr: bsr,
                      total_offers: total_offers,
                      title: title,
                      brand: brand,
                      fba_offers: 0)
  end

  def init_pair_variable
    @asin = pair[:asin]
    @quantity = pair[:package_quantity]
    @weight = pair[:weight]
    @title = pair[:title]
    @brand = pair[:brand]
  end

  def total_offers
    competitive_pricing.offer_count
  end

  def listing_price
    @listing_price ||= competitive_pricing.landed_price
  end

  def income
    @income = listing_price - amount_fees - quantity * cost - services_cost - weight * ship_to_fba
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
    @fees_by_current_asin ||= Amz::MyFeesEstimate.new(api_keys).call(marketplace: marketplace, asin: asin,
                                                                     price: listing_price)
  end

  def api_keys
    @api_keys ||= pricelist_record.task.api_keys
  end

  def cost
    pricelist_record.cost
  end

  def ship_to_fba
    pricelist_record.task.ship_to_fba
  end

  def services_cost
    pricelist_record.task.services_cost
  end
end
