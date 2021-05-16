# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pricelist do
  subject(:pricelist) { described_class.new(filename) }

  describe "#upc_column" do
    context "when upc column present" do
      let(:filename) { fixture_file_upload("correct.csv") }

      it "returns name of column" do
        expect(pricelist.upc_column).to eq :upc
      end
    end

    context "when upc column does not present" do
      let(:filename) { fixture_file_upload("incorrect.csv") }

      it "returns nil" do
        expect(pricelist.upc_column).to eq nil
      end
    end
  end

  describe "#cost_column" do
    context "when upc column present" do
      let(:filename) { fixture_file_upload("correct.csv") }

      it "returns name of column" do
        expect(pricelist.cost_column).to eq :cost
      end
    end

    context "when upc column does not present" do
      let(:filename) { fixture_file_upload("incorrect.csv") }

      it "returns nil" do
        expect(pricelist.cost_column).to eq nil
      end
    end
  end
end
