# frozen_string_literal: true

class SearchProductPairJob < ApplicationJob
  queue_as :search_queue

  def perform(pricelist_record)
    SearchProductPair.call(pricelist_record)
  end
end
