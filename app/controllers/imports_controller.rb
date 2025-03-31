class ImportsController < ApplicationController
    # POST /import
    def create
      logs = []

      begin
        data = JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        render json: { error: "Invalid JSON: #{e.message}" }, status: :unprocessable_entity and return
      end

      (data["restaurants"] || []).each do |rest_data|
        restaurant = Restaurant.find_or_create_by!(name: rest_data["name"]) do |r|
          r.location = rest_data["location"] || ""
          r.categories = rest_data["categories"] || []
        end

        (rest_data["menus"] || []).each do |menu_data|
          menu = restaurant.menus.find_or_create_by!(name: menu_data["name"]) do |m|
            m.description = menu_data["description"] || ""
          end

          items = menu_data["menu_items"] || menu_data["dishes"] || []
          items.each do |item_data|
            begin
              menu_item = MenuItem.find_or_create_by!(name: item_data["name"]) do |mi|
                mi.description = item_data["description"] || ""
              end

              # Join association with price for menu_item, allowing the same MenuItem to be used in different Menus with unique prices.
              association = menu.menu_menu_items.create!(menu_item: menu_item, price: item_data["price"])
              logs << {
                restaurant: restaurant.name,
                menu: menu.name,
                menu_item: menu_item.name,
                price: association.price,
                status: "Success"
              }
            rescue StandardError => e
              logs << {
                restaurant: restaurant.name,
                menu: menu.name,
                menu_item: item_data["name"],
                price: item_data["price"],
                status: "Failed",
                error: e.message
              }
            end
          end
        end
      end

      render json: { logs: logs }
    end
end
