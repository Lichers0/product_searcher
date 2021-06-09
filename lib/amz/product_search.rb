# frozen_string_literal: true

module Amz
  class ProductSearch < Amz::ApiService
    def initialize(seller_id:, mws_auth_token:, marketplace:)
      @marketplace = marketplace
      super(seller_id: seller_id, mws_auth_token: mws_auth_token)
    end

    def find_by(upc:)
      self.response = api_client.get_matching_product_for_id(marketplace, "UPC", upc)

      result_data
    end

    private

    attr_reader :marketplace

    def result_data
      products.map { |product| Amz::Asin.new(main_params(product)) }
    end

    def products
      result = response.dig("Products", "Product") || []
      result.is_a?(Array) ? result : [result]
    end

    def asin(product_hash)
      product_hash.dig("Identifiers", "MarketplaceASIN", "ASIN")
    end

    def items_attributes(product_hash)
      product_hash.dig("AttributeSets", "ItemAttributes")
    end

    def list_price(product_hash)
      items_attributes(product_hash).dig("ListPrice", "Amount") || 0
    end

    def weight(product_hash)
      items_attributes(product_hash).dig("PackageDimensions", "Weight", "__content__") || 0
    end

    def quantity(product_hash)
      items_attributes(product_hash).fetch("PackageQuantity", 1)
    end

    def title(product_hash)
      items_attributes(product_hash).fetch("Title")
    end

    def brand(product_hash)
      items_attributes(product_hash).fetch("Brand", "--")
    end

    def bsr(product_hash)
      product_hash.dig("SalesRankings", "SalesRank", 0, "Rank")
    end

    def main_params(product)
      {
        asin: asin(product),
        list_price: list_price(product).to_d,
        weight: weight(product).to_d,
        bsr: bsr(product).to_i,
        quantity: quantity(product).to_i,
        title: title(product),
        brand: brand(product)
      }
    end
  end
end
