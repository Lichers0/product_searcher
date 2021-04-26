# frozen_string_literal: true

class SearchPairsJob < ApplicationJob
  queue_as :search_product

  def perform(pricelist_line)
    seller_id, mws_auth_token = amazon_api_keys(pricelist_line)
    amazon_api = Service::AmazonApi.new(seller_id: seller_id, mws_auth_token: mws_auth_token)
    amazon_api.product_search(upc: pricelist_line.upc, cost: pricelist_line.cost)
  end

  private

  def amazon_api_keys(pricelist_line)
    seller_id = pricelist_line.task.seller_id
    mws_auth_token = pricelist_line.task.mws_auth_token
    [seller_id, mws_auth_token]
  end
end
