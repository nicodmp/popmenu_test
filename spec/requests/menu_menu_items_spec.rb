require 'rails_helper'

RSpec.describe "MenuMenuItems API", type: :request do
  let!(:restaurant) { Restaurant.create!(name: "Test Restaurant", location: "Location", categories: [ "Brazilian" ]) }
  let!(:menu) { restaurant.menus.create!(name: "Daily Menu", description: "A daily selection") }
  let!(:menu_item) { MenuItem.create!(name: "Churrasco", description: "Brazilian barbecue") }
  let!(:menu_menu_item) { menu.menu_menu_items.create!(menu_item: menu_item, price: 12.50) }

  describe "GET /menus/:menu_id/menu_menu_items" do
    it "returns the menu_menu_items for a given menu" do
      get "/menus/#{menu.id}/menu_menu_items"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(1)
      expect(json.first["price"].to_f).to eq(12.50)
    end
  end

  describe "GET /menus/:menu_id/menu_menu_items/:id" do
    it "returns a specific menu_menu_item" do
      get "/menu_menu_items/#{menu_menu_item.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["price"].to_f).to eq(12.50)
    end
  end

  describe "GET /menu_menu_items" do
    it "returns a list of all menu_menu_items" do
      get "/menu_menu_items"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to be >= 1
    end
  end
end
