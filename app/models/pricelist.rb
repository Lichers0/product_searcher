# frozen_string_literal: true

class Pricelist
  include Enumerable

  def initialize(file)
    @file = file
  end

  def import_columns_present?
    !!(upc_column && cost_column)
  end

  def each
    pricelist_data.each do |row|
      next if upc_empty?(row)

      yield params(row)
    end
  end

  private

  attr_reader :file

  def upc_empty?(row)
    row[upc_column].to_s.strip.empty?
  end

  def params(row)
    {
      upc: row[upc_column].to_s,
      cost: row[cost_column].to_s.sub(/[^0-9\\.]/, "").to_d
    }
  end

  def upc_column
    @upc_column ||= find_column("UPC")
  end

  def cost_column
    @cost_column ||= find_column("COST")
  end

  def find_column(column_name)
    columns.find { |column| column.to_s.casecmp?(column_name) }
  end

  def columns
    pricelist_data[0].keys
  end

  def pricelist_data
    @pricelist_data ||= SmarterCSV.process(file, { file_encoding: "" })
  end
end
