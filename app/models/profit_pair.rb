# frozen_string_literal: true

# == Schema Information
#
# Table name: profit_pairs
#
#  id                  :bigint           not null, primary key
#  asin                :string
#  brand               :string
#  bsr                 :integer
#  buybox_price        :decimal(8, 2)
#  fba_offers          :integer
#  income              :decimal(8, 2)
#  quantity_unit       :integer
#  title               :string
#  total_offers        :integer
#  weight              :decimal(8, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pricelist_record_id :bigint           not null
#
# Indexes
#
#  index_profit_pairs_on_pricelist_record_id  (pricelist_record_id)
#
# Foreign Keys
#
#  fk_rails_...  (pricelist_record_id => pricelist_records.id)
#
class ProfitPair < ApplicationRecord
  belongs_to :pricelist_record
end
