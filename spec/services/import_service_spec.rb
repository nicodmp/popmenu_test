require 'rails_helper'

RSpec.describe ImportService, type: :service do
  let(:valid_json) do
    '{
      "restaurants": [
        {
          "name": "Test Restaurant",
          "location": "Test Location",
          "categories": ["Mexican"],
          "menus": [
            {
              "name": "lunch",
              "menu_items": [
                {"name": "Burger", "price": 9.00},
                {"name": "Salad", "price": 5.00}
              ]
            }
          ]
        }
      ]
    }'
  end

  let(:json_with_alternate_key) do
    '{
      "restaurants": [
        {
          "name": "Alternate Restaurant",
          "menus": [
            {
              "name": "dinner",
              "dishes": [
                {"name": "Pasta", "price": 12.00}
              ]
            }
          ]
        }
      ]
    }'
  end

  let(:invalid_json) { "not a valid json" }

  context 'when processing valid JSON' do
    it 'creates the restaurant, menu, and menu items, and logs successes' do
      service = ImportService.new(valid_json)
      expect(service.process).to be true
      logs = service.logs

      expect(logs).not_to be_empty
      expect(logs.all? { |log| log[:status] == "Success" }).to be true

      restaurant = Restaurant.find_by(name: "Test Restaurant")
      expect(restaurant).not_to be_nil
      expect(restaurant.menus.first.name).to eq("lunch")

      menu = restaurant.menus.first
      burger_log = logs.find { |log| log[:menu_item] == "Burger" }
      expect(burger_log[:price]).to eq(9.00)
      expect(menu.menu_menu_items.where(menu_item: MenuItem.find_by(name: "Burger")).first.price).to eq(9.00)
    end
  end

  context 'when processing JSON with alternate key ("dishes")' do
    it 'processes the alternate key correctly' do
      service = ImportService.new(json_with_alternate_key)
      expect(service.process).to be true
      logs = service.logs

      restaurant = Restaurant.find_by(name: "Alternate Restaurant")
      expect(restaurant).not_to be_nil
      expect(restaurant.menus.first.name).to eq("dinner")

      pasta_log = logs.find { |log| log[:menu_item] == "Pasta" }
      expect(pasta_log).not_to be_nil
      expect(pasta_log[:price]).to eq(12.00)
    end
  end

  context 'when processing invalid JSON' do
    it 'logs a JSON parsing error and returns false' do
      service = ImportService.new(invalid_json)
      expect(service.process).to be false
      logs = service.logs
      expect(logs.first[:error]).to match(/Invalid JSON/)
    end
  end

  context 'when encountering duplicate menu items within the same menu' do
    let(:json_with_duplicates) do
      '{
        "restaurants": [
          {
            "name": "Duplicate Test",
            "menus": [
              {
                "name": "lunch",
                "menu_items": [
                  {"name": "Burger", "price": 10.00},
                  {"name": "Burger", "price": 10.00}
                ]
              }
            ]
          }
        ]
      }'
    end

    it 'logs a failure for the duplicate association' do
      service = ImportService.new(json_with_duplicates)
      service.process
      logs = service.logs

      success_logs = logs.select { |log| log[:status] == "Success" && log[:menu_item] == "Burger" }
      failure_logs = logs.select { |log| log[:status] == "Failed" && log[:menu_item] == "Burger" }

      expect(success_logs.size).to eq(1)
      expect(failure_logs.size).to eq(1)
      expect(failure_logs.first[:error]).to match(/has already been taken/)
    end
  end
end
