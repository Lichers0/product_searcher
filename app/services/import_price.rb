# frozen_string_literal: true

class ImportPrice < ApplicationService
  def initialize(task)
    @task = task
    super()
  end

  def call
    result = SmarterCSV.process(file_link)
    upc_name, cost_name = columns_name

    result.each do |line|
      upc = line[upc_name].to_s
      cost = line[cost_name].sub(/[^0-9\\.]/, "").to_d
      Pricelist.create!(task: task, upc: upc, cost: cost)
    end
  end

  private

  attr_reader :task

  def file_link
    @file_link ||= ActiveStorage::Blob.service.path_for(task.file.key)
  end

  def columns_name
    pricelist = Service::Pricelist.new(file_link)
    upc_name = pricelist.upc_column
    cost_name = pricelist.cost_column
    [upc_name, cost_name]
  end
end
