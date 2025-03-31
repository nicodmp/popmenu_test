require 'rails_helper'

RSpec.describe "Menus API", type: :request do
  let!(:restaurant) { Restaurant.create!(name: "Test Restaurant", location: "Location", categories: [ "Barbecue" ]) }
  let!(:menu1) { restaurant.menus.create!(name: "Lunch Menu", description: "Lunch options") }
  let!(:menu2) { restaurant.menus.create!(name: "Dinner Menu", description: "Dinner options") }

  describe "GET /restaurants/:restaurant_id/menus" do
    it "returns the menus for a given restaurant" do
      get "/restaurants/#{restaurant.id}/menus"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)
      expect(json.first["name"]).to eq(menu1.name)
    end
  end

  describe "GET /menus/:id" do
    it "returns a single menu" do
      get "/menus/#{menu1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(menu1.name)
    end
  end
end
