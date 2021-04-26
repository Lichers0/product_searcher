class ImportPriceJob < ApplicationJob
  queue_as :default

  def perform(task)
    ImportPrice.call(task)
  end
end
