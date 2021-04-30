# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pricelist do
  subject(:pricelist) { described_class.new(filename) }

  let(:price_correct) { [{ Upc: 123_456_789_012, cost: "$ 2.50" }] }
  let(:price_incorrect) { [{ Upc1: 123_456_789_012, cost1: "$ 2.50" }] }
  let(:filename) { "correct.csv" }

  describe "#upc_column" do
    context "when upc column present" do
      it "returns name of column" do
        allow(SmarterCSV).to receive(:process).with(filename).and_return(price_correct)

        expect(pricelist.upc_column).to eq :Upc
      end
    end

    context "when upc column does not present" do
      it "returns nil" do
        allow(SmarterCSV).to receive(:process).with(filename).and_return(price_incorrect)

        expect(pricelist.upc_column).to eq nil
      end
    end
  end

  describe "#cost_column" do
    context "when upc column present" do
      it "returns hash key" do
        allow(SmarterCSV).to receive(:process).with(filename).and_return(price_correct)

        expect(pricelist.cost_column).to eq :cost
      end
    end

    context "when upc column does not present" do
      it "returns nil" do
        allow(SmarterCSV).to receive(:process).with(filename).and_return(price_incorrect)

        expect(pricelist.cost_column).to eq nil
      end
    end
  end
end
