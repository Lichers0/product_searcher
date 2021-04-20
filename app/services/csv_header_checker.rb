# frozen_string_literal: true

class CsvHeaderChecker < ApplicationService
  COLUMN_NAME = %w[UPC COST].freeze

  def initialize(file)
    @file = file
    super()
  end

  def call
    result = SmarterCSV.process(file)
    self.error = result[0].keys.map(&:to_s).map(&:upcase).count { |value| COLUMN_NAME.include?(value) } != 2
    self
  end

  def error?
    error
  end

  private

  attr_reader :file
  attr_accessor :error
end
