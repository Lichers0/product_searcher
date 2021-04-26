# frozen_string_literal: true

class CreateSearchQueue < ApplicationService
  def initialize(task)
    @task = task
    super()
  end

  def call
    count = 0
    Pricelist.where(task: task).in_batches.each do |record|
      CreateSearchQueueJob.perform_later(record)
      count += 1
      break if count > 5
    end
  end
end
