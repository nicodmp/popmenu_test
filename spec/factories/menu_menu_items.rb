FactoryBot.define do
    factory :menu_menu_item do
      association :menu
      association :menu_item
      price { Faker::Commerce.price(range: 1.0..100.0) }
    end
  end
  