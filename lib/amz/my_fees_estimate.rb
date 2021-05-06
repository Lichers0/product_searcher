# frozen_string_literal: true

module Amz
  class MyFeesEstimate
    delegate :credentials, to: :'Rails.application'

    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
    end

    def call(marketplace:, asin:, price:)
      client = MWS::Products::Client.new(reports_params)
      @response = client.get_my_fees_estimate(request_params(marketplace: marketplace, asin: asin, price: price))
      self
    rescue Peddler::Errors::Error => e
      e
    end

    def amount
      fees_estimate&.dig("TotalFeesEstimate", "Amount").to_d || -1
    end

    private

    attr_reader :seller_id, :mws_auth_token

    def result_hash
      {
        amount: amount.to_d,
        referral_fee: referral_fee.to_d,
        fba_fee: fba_fee.to_d
      }
    end

    def fees_estimate
      @fees_estimate ||= @response.dig("FeesEstimateResultList", "FeesEstimateResult", "FeesEstimate")
    end

    def fee_detail
      @fee_detail ||= fees_estimate.dig("FeeDetailList", "FeeDetail")
    end

    def referral_fee
      fee_detail.find { |record| record["FeeType"] == "ReferralFee" }&.dig("FeeAmount", "Amount") || -1.0
    end

    def fba_fee
      fee_detail.find { |record| record["FeeType"] == "FBAFees" }.dig("FeeAmount", "Amount") || -1.0
    end

    def reports_params
      {
        marketplace: "US",
        merchant_id: seller_id,
        aws_access_key_id: credentials.mws[:aws_access_key_id],
        aws_secret_access_key: credentials.mws[:aws_secret_access_key],
        auth_token: mws_auth_token
      }
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
