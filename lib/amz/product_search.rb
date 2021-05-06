# frozen_string_literal: true

module Amz
  class ProductSearch
    delegate :credentials, to: :'Rails.application'

    def initialize(seller_id:, mws_auth_token:)
      @seller_id = seller_id
      @mws_auth_token = mws_auth_token
    end

    def call(marketplace:, upc:)
      client = MWS::Products::Client.new(reports_params)
      @response = client.get_matching_product_for_id(marketplace, "UPC", formated_upc(upc))
      result = []
      return [] if invalid_upc

      products.each do |product|
        result << result_hash(product)
      end
      result
    rescue Peddler::Errors::Error => e
      e
    end

    private

    attr_reader :seller_id, :mws_auth_token

    def invalid_upc
      return true if @response.body.include? "Invalid UPC identifier"

      false
    end

    def formated_upc(upc)
      format("%012d", upc.to_i)
    end

    def result_hash(product)
      {
        asin: asin(product),
        list_price: list_price(product).to_i,
        weight: weight(product).to_d,
        sales_rank: sales_rank(product).to_i,
        package_quantity: package_quantity(product).to_i,
        brand: brand(product),
        title: title(product)
      }
    end

    def products
      result = @response.dig("Products", "Product")
      result.is_a?(Array) ? result : [result]
    end

    def package_quantity(product_hash)
      product_hash.dig("AttributeSets", "ItemAttributes", "PackageQuantity") || 0
    end

    def brand(product_hash)
      product_hash.dig("AttributeSets", "ItemAttributes", "Brand") || ""
    end

    def title(product_hash)
      product_hash.dig("AttributeSets", "ItemAttributes", "Title") || ""
    end

    def sales_rank(product_hash)
      product_hash.dig("SalesRankings", "SalesRank", 0, "Rank") || 0
    end

    def weight(product_hash)
      product_hash&.dig("AttributeSets", "ItemAttributes", "PackageDimensions", "Weight", "__content__") || 0
    end

    def asin(product_hash)
      product_hash.dig("Identifiers", "MarketplaceASIN", "ASIN")
    end

    def list_price(product_hash)
      product_hash&.dig("AttributeSets", "ItemAttributes", "ListPrice", "Amount") || 0
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
  end
end
