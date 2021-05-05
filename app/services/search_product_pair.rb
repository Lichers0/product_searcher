# frozen_string_literal: true

class SearchProductPair < ApplicationService
  def initialize(pricelist_record)
    @pricalist_record = pricelist_record
    super()
  end

  def call
    product_pair_list
  end

  private

  attr_reader :pricelist_record

  def product_pair_list
    AMZ::ProductSearch.new(user_api_keys).find_product(upc: upc)
  end

  def user_api_keys
    @user_api_keys ||= pricelist_record.task.user_api_keys
  end

  def upc
    pricelist_record.upc
  end
end
