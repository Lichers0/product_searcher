# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductPair do
  context "when bsr is invalid" do
    context "when bsr is zero" do
      it "do NOT save this pair to db" do
        allow(ProfitPair).to receive(:create)
        pricelist_record = build(:pricelist_record)
        pair = instance_double(Amz::Asin, bsr: 0)

        described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

        expect(ProfitPair).not_to have_received(:create)
      end
    end

    context "when bsr is more then 100_000" do
      it "do NOT save this pair to db" do
        max_best_sellers_rank = 100_000
        allow(ProfitPair).to receive(:create)
        pricelist_record = build(:pricelist_record)
        pair = instance_double(Amz::Asin, bsr: max_best_sellers_rank + 1)

        described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

        expect(ProfitPair).not_to have_received(:create)
      end
    end
  end

  context "when pair if NOT profitable" do
    it "do NOT save this pair to db" do
      pricelist_record = build(:pricelist_record)
      bsr_valid = 50_000
      pair = instance_double(Amz::Asin, bsr: bsr_valid).as_null_object
      unprofitable = 0.3
      product_pair_income = instance_double(ProductPairIncome, amount: unprofitable).as_null_object
      allow(ProductPairIncome).to receive(:new).and_return(product_pair_income)
      task = build(:task)
      allow(pricelist_record).to receive(:task).and_return(task)
      allow(ProfitPair).to receive(:create)

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).not_to have_received(:create)
    end
  end

  context "when bsr is invalid and pair is NOT profitable" do
    it "do NOT save this pair to db" do
      pricelist_record = build(:pricelist_record)
      bsr_invalid = 150_000
      pair = instance_double(Amz::Asin, bsr: bsr_invalid).as_null_object
      unprofitable = 0.3
      product_pair_income = instance_double(ProductPairIncome, amount: unprofitable).as_null_object
      allow(ProductPairIncome).to receive(:new).and_return(product_pair_income)
      task = build(:task)
      allow(pricelist_record).to receive(:task).and_return(task)
      allow(ProfitPair).to receive(:create)

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).not_to have_received(:create)
    end
  end

  context "when bsr is valid and pair is profitable" do
    it "saves profit pair to db" do
      pricelist_record = build(:pricelist_record)
      bsr_valid = 50_000
      pair = instance_double(Amz::Asin, bsr: bsr_valid).as_null_object
      profitable = 1.5
      product_pair_income = instance_double(ProductPairIncome, amount: profitable).as_null_object
      allow(ProductPairIncome).to receive(:new).and_return(product_pair_income)
      task = build(:task)
      allow(pricelist_record).to receive(:task).and_return(task)
      allow(ProfitPair).to receive(:create)

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).to have_received(:create)
    end
  end
end
