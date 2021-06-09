# frozen_string_literal: true

class PricelistProduct
  def initialize(pricelist_record)
    @pricelist_record = pricelist_record
  end

  def search_profit_pair
    amazon_products.each do |pair|
      product_pair = ProductPair.new(pricelist_record: pricelist_record, pair: pair)
      product_pair.save_if_profitable
    end

    pricelist_record.update(processed: true)
  end

  private

  delegate :upc, to: :pricelist_record

  attr_reader :pricelist_record

  def marketplace
    @marketplace ||= Peddler::Marketplace.find("US").id
  end

  def amazon_products
    Amz::ProductSearch.new(api_keys).find_by(marketplace: marketplace, upc: upc)
  end

  def api_keys
    @api_keys ||= pricelist_record.task.api_keys
  end
end
