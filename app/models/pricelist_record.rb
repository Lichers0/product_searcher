# frozen_string_literal: true

# == Schema Information
#
# Table name: pricelist_records
#
#  id         :bigint           not null, primary key
#  cost       :decimal(8, 2)
#  processed  :boolean          default(FALSE)
#  upc        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :bigint           not null
#
# Indexes
#
#  index_pricelist_records_on_task_id  (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#
class PricelistRecord < ApplicationRecord
  belongs_to :task

  scope :unprocessed, ->(task) { where(task: task, processed: false) }
end
