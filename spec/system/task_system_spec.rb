# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Task", type: :system do
  it "creates task" do
    visit root_path
    click_on "Create Task"

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "SellerID can't be blank"
    expect(page).to have_content "MWS Auth Token can't be blank"
    expect(page).to have_content "Ship to FBA can't be blank"
    expect(page).to have_content "Services cost can't be blank"
    expect(page).to have_content "File can't be blank"
    expect(page).to have_content "Wrong amazon api key"
  end
end
