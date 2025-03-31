require 'rails_helper'

RSpec.describe "Restaurants API", type: :request do
  let!(:restaurant1) { Restaurant.create!(name: "Test Restaurant 1", location: "Location 1", categories: [ "Mexican" ]) }
  let!(:restaurant2) { Restaurant.create!(name: "Test Restaurant 2", location: "Location 2", categories: [ "Italian" ]) }

  describe "GET /restaurants" do
    it "returns a list of restaurants" do
      get "/restaurants"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)
    end
  end

  describe "GET /restaurants/:id" do
    it "returns the specified restaurant" do
      get "/restaurants/#{restaurant1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(restaurant1.name)
    end
  end
end
