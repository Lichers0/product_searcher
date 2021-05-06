# frozen_string_literal: true

class ProfitPairsController < ApplicationController
  def index
    @pagy, @profit_pairs = pagy(ProfitPair.order(:bsr), items: 50)
  end
end
