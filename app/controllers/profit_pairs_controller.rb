# frozen_string_literal: true

class ProfitPairsController < ApplicationController
  def index
    @pagy, @profit_pairs = pagy(
      ProfitPair
        .joins(:pricelist_record)
        .where(pricelist_record: { task_id: params[:task_id] })
        .order(:bsr), items: 50
    )
  end
end
