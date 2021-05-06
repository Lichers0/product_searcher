FactoryBot.define do
  factory :profit_pair do
    asin { "MyString" }
    income { "9.99" }
    weight { "9.99" }
    quantity_unit { 1 }
    buybox_price { "9.99" }
    pricelist_record { nil }
  end
end
