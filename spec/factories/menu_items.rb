FactoryBot.define do
    factory :menu_item do
      name { Faker::Food.unique.dish }
      description { Faker::Food.description }
    end
  end
