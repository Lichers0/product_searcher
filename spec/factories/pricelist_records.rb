# frozen_string_literal: true

FactoryBot.define do
  factory :pricelist_record do
    task
    processed { false }
    cost { 10.50 }
    upc { "035585800158" }

    trait :low_cost do
      cost { 0.1 }
    end
  end
end
