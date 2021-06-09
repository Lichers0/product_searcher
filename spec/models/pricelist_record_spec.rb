# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricelistRecord, type: :model do
  describe ".unprocessed" do
    it "includes unprocessed records" do
      task = create_task

      unprocessed_record = described_class.create(task: task, processed: false)
      described_class.create(task: task, processed: true)

      expect(described_class.unprocessed(task)).to eq [unprocessed_record]
    end
  end
end
