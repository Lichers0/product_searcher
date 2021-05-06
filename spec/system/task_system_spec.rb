# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Task", type: :system do
  it "creates task" do
    VCR.use_cassette("user_api_keys/valid_keys") do
      task = build(:task)

      visit root_path
      click_on "Create Task"

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "SellerID can't be blank"
      expect(page).to have_content "MWS Auth Token can't be blank"
      expect(page).to have_content "Ship to FBA can't be blank"
      expect(page).to have_content "Services cost can't be blank"
      expect(page).to have_content "File can't be blank"
      expect(page).to have_content "Wrong amazon api key"

      fill_in :task_email, with: task.email
      fill_in :task_seller_id, with: task.seller_id
      fill_in :task_mws_auth_token, with: task.mws_auth_token
      fill_in :task_ship_to_fba, with: task.ship_to_fba
      fill_in :task_services_cost, with: task.services_cost
      attach_file :task_file, Rails.root.join("spec/fixtures/files/correct.csv")

      click_on "Create Task"

      expect(page).to have_content "Task#create"
      expect(Task.count).to eq 1
    end
  end
end
