# frozen_string_literal: true

class SearchProductPairJob < ApplicationJob
  queue_as :search_queue

  def perform(product)
    PricelistProduct.new(product).search_profit_pair
  end
end
