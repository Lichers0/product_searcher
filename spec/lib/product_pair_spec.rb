# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductPair do
  let(:pricelist_record) { build(:pricelist_record) }

  before { allow(ProfitPair).to receive(:create) }

  context "when bsr is invalid" do
    context "and when bsr is zero" do
      it "does NOT save this pair to db" do
        pair = instance_double(Amz::Asin, bsr: 0)

        described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

        expect(ProfitPair).not_to have_received(:create)
      end
    end

    context "and when bsr is more then 100_000" do
      it "does NOT save this pair to db" do
        max_best_sellers_rank = 100_000
        pair = instance_double(Amz::Asin, bsr: max_best_sellers_rank + 1)

        described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

        expect(ProfitPair).not_to have_received(:create)
      end
    end
  end

  context "when pair is NOT profitable" do
    it "does NOT save this pair to db" do
      pair = build_valid_pair

      stub_unprofitable_income

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).not_to have_received(:create)
    end
  end

  context "when bsr is invalid and pair is NOT profitable" do
    it "does NOT save this pair to db" do
      pair = build_invalid_pair

      stub_unprofitable_income

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).not_to have_received(:create)
    end
  end

  context "when bsr is valid and pair is profitable" do
    it "saves profit pair to db" do
      pair = build_valid_pair

      stub_profitable_income

      described_class.new(pricelist_record: pricelist_record, pair: pair).save_if_profitable

      expect(ProfitPair).to have_received(:create)
    end
  end

  def stub_unprofitable_income
    profitable = 0.5
    product_pair_income = instance_double(ProductPairIncome, amount: profitable).as_null_object
    allow(ProductPairIncome).to receive(:new).and_return(product_pair_income)
  end

  def stub_profitable_income
    profitable = 1.5
    product_pair_income = instance_double(ProductPairIncome, amount: profitable).as_null_object
    allow(ProductPairIncome).to receive(:new).and_return(product_pair_income)
  end

  def build_invalid_pair
    invalid_bsr = 150_000
    instance_double(Amz::Asin, bsr: invalid_bsr).as_null_object
  end

  def build_valid_pair
    valid_bsr = 50_000
    instance_double(Amz::Asin, bsr: valid_bsr).as_null_object
  end
end
