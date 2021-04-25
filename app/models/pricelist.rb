# frozen_string_literal: true

class Pricelist
  def initialize(file)
    @file = file
  end

  def upc_column
    @upc_column ||= find_column("UPC")
  end

  def cost_column
    @cost_column ||= find_column("COST")
  end

  private

  def import_columns_present?
    upc_column && cost_column
  end

  def find_column(column_name)
    price_columns.find { |column| column.to_s.upcase == column_name }
  end

  def price_columns
    result = SmarterCSV.process(@file)
    result[0].keys
  end
end
