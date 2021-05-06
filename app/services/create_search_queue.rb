# frozen_string_literal: true

class CreateSearchQueue < ApplicationService
  def initialize(task)
    @task = Task.find(task.id)
    super()
  end

  def call
    count = 0
    PricelistRecord.where(task: @task, processed: false).find_each(batch_size: 1) do |record|
      SearchProductPairJob.perform_later(record)
      count += 1
      # return "done" if count > 1000
    end

    count
  end
end
