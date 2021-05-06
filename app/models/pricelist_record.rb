# frozen_string_literal: true

class PricelistRecord < ApplicationRecord
  belongs_to :task
  has_many :profit_pairs, dependent: :destroy
end
