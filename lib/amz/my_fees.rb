# frozen_string_literal: true

module Amz
  class MyFees < Amz::ApiService
    def initialize(seller_id:, mws_auth_token:, marketplace:)
      @marketplace = marketplace
      super(seller_id: seller_id, mws_auth_token: mws_auth_token)
    end

    def estimate(asin:, price:)
      @response = client.get_my_fees_estimate(
        request_params(marketplace: marketplace, asin: asin, price: price)
      )

      self
    end

    def amount
      fees_estimate&.dig("TotalFeesEstimate", "Amount").to_d || -1
    end

    def details
      {
        amount: amount,
        referral_fee: referral_fee,
        fba_fee: fba_fee
      }
    end

    alias amount_fees amount

    private

    attr_reader :marketplace

    def fees_estimate
      @fees_estimate ||= response.dig("FeesEstimateResultList", "FeesEstimateResult", "FeesEstimate")
    end

    def fee_detail
      @fee_detail ||= fees_estimate&.dig("FeeDetailList", "FeeDetail")
    end

    def referral_fee
      fee_detail
        .find { |record| record["FeeType"] == "ReferralFee" }
        &.dig("FeeAmount", "Amount").to_d || -1.0
    end

    def fba_fee
      fee_detail
        .find { |record| record["FeeType"] == "FBAFees" }
        &.dig("FeeAmount", "Amount").to_d || -1.0
    end

    def request_params(marketplace:, asin:, price:)
      {
        MarketplaceId: marketplace,
        IdType: "ASIN",
        IdValue: asin,
        IsAmazonFulfilled: true,
        Identifier: "asin #{asin}",
        PriceToEstimateFees: { ListingPrice: { Amount: price, CurrencyCode: "USD" } }
      }
    end
  end
end
