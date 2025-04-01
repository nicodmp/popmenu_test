FactoryBot.define do
    factory :menu do
      name { "Menu #{Faker::Food.ethnic_category}" }
      description { Faker::Restaurant.description }
      association :restaurant
    end
  end
  