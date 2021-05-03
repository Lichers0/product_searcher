# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :task do
    email
    seller_id { "AAQHWTH6HF5BV" }
    mws_auth_token { "amzn.mws.6eb293fe-7935-feb0-f562-4c4650cd3837" }
    ship_to_fba { 0.3 }
    services_cost { 0.5 }
  end
end
