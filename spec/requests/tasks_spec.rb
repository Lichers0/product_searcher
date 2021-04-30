# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "POST /tasks" do
    subject(:http_request) { post tasks_path, params: { task: task } }

    let(:csv_file) { fixture_file_upload("correct.csv") }
    let(:task) { attributes_for(:task, file: csv_file) }
    let(:client) { instance_double(MWS::Reports::Client) }

    it "test" do
      allow(MWS::Reports::Client).to receive(:new).and_return(client)
      allow(client).to receive(:get_report_count).and_return({})

      expect { http_request }.to change(Task, :count).by(1)
    end
  end
end
