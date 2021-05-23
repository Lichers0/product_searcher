# frozen_string_literal: true

module Amz
  class Asin
    attr_reader :asin, :list_price, :weight, :bsr, :quantity, :title, :brand

    def initialize(params)
      @asin = params[:asin]
      @list_price = params[:list_price]
      @weight = params[:weight]
      @bsr = params[:bsr]
      @quantity = params[:quantity]
      @title = params[:title]
      @brand = params[:brand]
    end
  end
end
