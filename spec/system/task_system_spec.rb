# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Task", type: :system do
  it "creates task" do
    VCR.use_cassette("user_api_keys/valid_keys") do
      visit root_path
      click_on "Create Task"

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "SellerID can't be blank"
      expect(page).to have_content "MWS Auth Token can't be blank"
      expect(page).to have_content "Ship to FBA can't be blank"
      expect(page).to have_content "Services cost can't be blank"
      expect(page).to have_content "File can't be blank"
      expect(page).to have_content "Wrong amazon api key"

      fill_in :task_email, with: "user@test.com"
      fill_in :task_seller_id, with: "AAQHWTH7HF8B1"
      fill_in :task_mws_auth_token, with: "amzn.mws.6eb293fe-7935-feb0-f562-4c4650cff837"
      fill_in :task_ship_to_fba, with: 0.3
      fill_in :task_services_cost, with: 0.5
      attach_file :task_file, Rails.root.join("spec/fixtures/files/correct.csv")

      expect { click_on "Create Task" }.to change(Task, :count).by(1)

      expect(page).to have_confirmation_message
    end
  end

  def have_confirmation_message
    have_content "Task created"
  end
end
