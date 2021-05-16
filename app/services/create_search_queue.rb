# frozen_string_literal: true

class CreateSearchQueue < ApplicationService
  def initialize(task)
    @task = task
    super()
  end

  def call
    PricelistRecord.where(task: task, processed: false).in_batches.each do |record|
      SearchProductPairJob.perform_later(record)
    end
  end
end
