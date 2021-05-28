# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pricelist do
  describe "#import_columns_present?" do
    context "when upc column present" do
      it "returns true" do
        filename = fixture_file_upload("correct.csv")
        pricelist = described_class.new(filename)

        expect(pricelist).to be_import_columns_present
      end
    end

    context "when upc column does not present" do
      it "returns false" do
        filename = fixture_file_upload("incorrect.csv")
        pricelist = described_class.new(filename)

        expect(pricelist).not_to be_import_columns_present
      end
    end
  end

  describe "#each" do
    it "returns all pricelist's objects" do
      filename = fixture_file_upload("correct.csv")
      pricelist = described_class.new(filename)

      yielded = pricelist.map { |element| element }

      expect(yielded).to eq [{ cost: 2.507, upc: "644472002096" }, { cost: 2.507, upc: "644472002102" }]
    end
  end
end
