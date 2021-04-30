# frozen_string_literal: true

require "rails_helper"

RSpec.describe AmazonUserApiKeys do
  describe "valid?" do
    subject(:user_api_keys) { described_class.new({ seller_id: 123, mws_auth_token: 123 }) }

    let(:client) { instance_double(MWS::Reports::Client) }
    let(:reports_params) { { report_type_list: "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_" } }

    before do
      allow(MWS::Reports::Client).to receive(:new).and_return(client)
    end

    context "when api keys valid" do
      it "returns true" do
        allow(client).to receive(:get_report_count).with(reports_params).and_return({})

        expect(user_api_keys.valid?).to be_truthy # rubocop:disable RSpec/PredicateMatcher
      end
    end

    context "when api keys does not valid" do
      it "returns false" do
        allow(client).to receive(:get_report_count).with(reports_params).and_raise(Peddler::Errors::Error)

        expect(user_api_keys).not_to be_valid
      end
    end
  end
end
