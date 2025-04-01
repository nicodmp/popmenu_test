FactoryBot.define do
    factory :restaurant do
      name { Faker::Restaurant.name }
      location { Faker::Address.full_address }
      categories { [Faker::Restaurant.type] }
    end
  end
  