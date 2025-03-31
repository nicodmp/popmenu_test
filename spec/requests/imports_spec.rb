require 'rails_helper'

RSpec.describe "Imports API", type: :request do
  let(:valid_json) do
    '{
      "restaurants": [
        {
          "name": "Poppo\'s Cafe",
          "menus": [
            {
              "name": "lunch",
              "menu_items": [
                {"name": "Burger", "price": 9.00},
                {"name": "Small Salad", "price": 5.00}
              ]
            },
            {
              "name": "dinner",
              "menu_items": [
                {"name": "Burger", "price": 15.00},
                {"name": "Large Salad", "price": 8.00}
              ]
            }
          ]
        }
      ]
    }'
  end

  let(:invalid_json) { "not a valid json" }

  describe "POST /import" do
    context "with valid JSON" do
      it "imports the data and returns logs with success" do
        post "/import", params: valid_json, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["logs"]).to be_an(Array)
        expect(json["logs"].all? { |log| log["status"] == "Success" }).to be true
      end
    end

    context "with invalid JSON" do
      it "returns an error" do
        post "/import", params: invalid_json, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("Invalid JSON")
      end
    end
  end
end
