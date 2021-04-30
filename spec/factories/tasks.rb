# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :task do
    email
    seller_id { "123" }
    mws_auth_token { "123" }
    ship_to_fba { "0.3" }
    services_cost { "0.5" }
  end
end
