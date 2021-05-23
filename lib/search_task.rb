# frozen_string_literal: true

class SearchTask
  def initialize(task)
    @task = task
  end

  def create
    # import_pricelist
    create_search_jobs_for_pricelist_records
  end

  private

  delegate :pricelist_link, to: :task

  attr_reader :task

  def unprocessed_records
    PricelistRecord.unprocessed(task)
  end

  def create_search_jobs_for_pricelist_records
    unprocessed_records.each do |record|
      SearchProductPairJob.perform_later(record)
    end
  end

  def pricelist_csv
    Pricelist.new(pricelist_link)
  end

  def import_pricelist
    pricelist_csv.each do |record|
      PricelistRecord.create!(record.merge(task: task))
    end
  end
end
