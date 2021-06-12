# frozen_string_literal: true

module Amz
  def api_keys_and_marketplace
    attributes_for(:task)
      .slice(:seller_id, :mws_auth_token)
      .merge(marketplace: marketplace_us)
  end

  def marketplace_us
    Peddler::Marketplace.find("US").id
  end
end
