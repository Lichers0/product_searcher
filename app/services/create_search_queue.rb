# frozen_string_literal: true

class CreateSearchQueue < ApplicationService
  def initialize(task)
    @task = task
    super()
  end

  def call
    count = 0
    PricelistRecord.where(task: task, processed: false).in_batches.each do |record|
      SearchProductPairJob.perform_later(record)
      count += 1
      break if count > 2
    end
  end
end
