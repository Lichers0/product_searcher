# frozen_string_literal: true

class SearchProductPair < ApplicationService
  def initialize(pricelist_record)
    @pricelist_record = pricelist_record
    super()
  end

  def call
    pair_by_current_upc.each do |pair|
      CheckProductPair.call(pricelist_record: pricelist_record,
                            pair: pair)
    end

    pricelist_record.update(processed: true)
  end

  private

  attr_reader :pricelist_record

  def marketplace
    @marketplace ||= Peddler::Marketplace.find("US").id
  end

  def pair_by_current_upc
    Amz::ProductSearch.new(api_keys).call(marketplace: marketplace, upc: upc)
  end

  def api_keys
    @api_keys ||= pricelist_record.task.api_keys
  end

  def upc
    pricelist_record.upc
  end
end
