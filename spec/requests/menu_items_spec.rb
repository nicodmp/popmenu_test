require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:menu_item1) { MenuItem.create!(name: "Burger", description: "Beef burger") }
  let!(:menu_item2) { MenuItem.create!(name: "Salad", description: "Fresh salad") }

  describe "GET /menu_items" do
    it "returns a list of menu items" do
      get "/menu_items"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)
    end
  end

  describe "GET /menu_items/:id" do
    it "returns a specific menu item" do
      get "/menu_items/#{menu_item1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(menu_item1.name)
    end
  end
end
