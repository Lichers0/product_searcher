# frozen_string_literal: true

class ProductSearch
  delegate :credentials, to: :'Rails.application'

  def initialize(seller_id:, mws_auth_token:)
    @seller_id = seller_id
    @mws_auth_token = mws_auth_token
  end

  def find(marketplace:, upc:)
    client = MWS::Products::Client.new(reports_params)
    @response = client.get_matching_product_for_id(marketplace, "UPC", upc)
    result = []
    @response.dig("Products", "Product").each do |product|
      result << main_params(product)
    end
    result
  end

  private

  attr_reader :seller_id, :mws_auth_token

  def main_params(product)
    {
      asin: asin(product),
      list_price: list_price(product),
      weight: weight(product),
      sales_rank: sales_rank(product),
      package_quantity: package_quantity(product)
    }
  end

  def package_quantity(product_hash)
    product_hash.dig("AttributeSets", "ItemAttributes", "PackageQuantity")
  end

  def sales_rank(product_hash)
    product_hash.dig("SalesRankings", "SalesRank", 0, "Rank")
  end

  def weight(product_hash)
    product_hash.dig("AttributeSets", "ItemAttributes", "PackageDimensions", "Weight", "__content__")
  end

  def asin(product_hash)
    product_hash.dig("Identifiers", "MarketplaceASIN", "ASIN")
  end

  def list_price(product_hash)
    product_hash.dig("AttributeSets", "ItemAttributes", "ListPrice", "Amount")
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
