# frozen_string_literal: true

class ImportPricelist < ApplicationService
  def initialize(task)
    @task = task
    super()
  end

  def call
    pricelist_data.each do |row|
      PricelistRecord.create!(params(row))
    end
    # CreateSearchQueue.call(task)
  end

  private

  attr_reader :task

  def params(row)
    {
      task: task,
      upc: row[upc_column].to_s,
      cost: row[cost_column].sub(/[^0-9\\.]/, "").to_d
    }
  end

  def pricelist_data
    @pricelist_data = SmarterCSV.process(task.pricelist_link)
  end

  def pricelist
    @pricelist ||= Pricelist.new(task.pricelist_link)
  end

  def upc_column
    @upc_column ||= pricelist.upc_column
  end

  def cost_column
    @cost_column ||= pricelist.cost_column
  end
end
