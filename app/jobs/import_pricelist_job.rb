# frozen_string_literal: true

class ImportPricelistJob < ApplicationJob
  queue_as :default

  def perform(task)
    ImportPricelist.call(task)
  end
end
