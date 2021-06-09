# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :task do
    email
    seller_id { "AAQHWTH7HF8BV" }
    mws_auth_token { "amzn.mws.6eb293fe-7935-feb0-f562-4c4650cff837" }
    ship_to_fba { 0.3 }
    services_cost { 0.5 }

    trait :correct_price do
      file { fixture_file_upload(Rails.root.join("spec/fixtures/files/correct.csv")) }
    end
  end
end
