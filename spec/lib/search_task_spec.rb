# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchTask do
  describe "#create" do
    it "imports task csv file to db" do
      task = create_task

      expect { described_class.new(task).create }.to change(PricelistRecord, :count).by(2)
    end

    it "creates active job for each row of task csv file" do
      task = create_task
      allow(SearchProductPairJob).to receive(:perform_later)

      described_class.new(task).create

      expect(SearchProductPairJob).to have_received(:perform_later).twice
    end
  end
end
