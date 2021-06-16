# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricelistProduct do
  describe "#search_profit_pair" do
    it "marks pricelist record as processed" do
      task = create(:task, :correct_price)
      pricelist_record = create(:pricelist_record, task: task)
      product_search = instance_double(Amz::ProductSearch, find_by: [])
      allow(Amz::ProductSearch).to receive(:new).and_return(product_search)

      expect { described_class.new(pricelist_record).search_profit_pair }
        .to change { pricelist_record.reload.processed }.from(false).to(true)
    end

    it "finds profitable product pair" do
      asin1 = instance_double(Amz::Asin)
      asin2 = instance_double(Amz::Asin)
      product_search = instance_double(Amz::ProductSearch, find_by: [asin1, asin2])
      allow(Amz::ProductSearch).to receive(:new).and_return(product_search)
      task = create(:task, :correct_price)
      pricelist_record = create(:pricelist_record, task: task)
      product_pair = instance_double(ProductPair, save_if_profitable: "")
      allow(ProductPair).to receive(:new).and_return(product_pair)

      described_class.new(pricelist_record).search_profit_pair

      expect(product_pair).to have_received(:save_if_profitable).twice
    end
  end
end
