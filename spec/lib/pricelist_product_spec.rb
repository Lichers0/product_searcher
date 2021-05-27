# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricelistProduct do
  describe "#search_profit_pair" do
    it "updates status pricelist record when search done" do
      VCR.use_cassette "search_profit_pair" do
        task = create(:task, :correct_price, ship_to_fba: 0.1, services_cost: 0.1)
        pricelist_record = create(:pricelist_record, upc: "035585800158", cost: 0.1, task: task)

        expect { described_class.new(pricelist_record).search_profit_pair }
          .to change(PricelistRecord.where(processed: true), :count).by(1)
      end
    end

    it "Saves profit pair to db" do
      VCR.use_cassette "search_profit_pair" do
        task = create(:task, :correct_price, ship_to_fba: 0.1, services_cost: 0.1)
        pricelist_record = create(:pricelist_record, upc: "035585800158", cost: 0.1, task: task)

        expect { described_class.new(pricelist_record).search_profit_pair }
          .to change(ProfitPair, :count).by(1)
      end
    end
  end
end
