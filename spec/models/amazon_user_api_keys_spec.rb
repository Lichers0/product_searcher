# frozen_string_literal: true

require "rails_helper"

RSpec.describe AmazonUserApiKeys do
  describe "#valid?" do
    subject(:user_api_keys) { described_class.new(task.api_keys) }

    let(:task) { build(:task, file: fixture_file_upload("correct.csv")) }

    context "when api keys are valid" do
      it "returns true" do
        VCR.use_cassette("user_api_keys/valid_keys") do
          expect(user_api_keys).to be_valid
        end
      end
    end

    context "when api keys are invalid" do
      it "returns false" do
        VCR.use_cassette("user_api_keys/invalid_keys") do
          expect(user_api_keys).not_to be_valid
        end
      end
    end
  end
end
