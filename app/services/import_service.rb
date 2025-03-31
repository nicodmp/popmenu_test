class ImportService
    attr_reader :logs

    def initialize(json_data)
      @json_data = json_data
      @logs = []
    end

    def process
      data = parse_json
      return false unless data

      (data["restaurants"] || []).each do |rest_data|
        process_restaurant(rest_data)
      end

      true
    rescue StandardError => e
      @logs << { status: "Failed", error: "Unexpected error: #{e.message}" }
      false
    end

    private

    def parse_json
      JSON.parse(@json_data)
    rescue JSON::ParserError => e
      @logs << { status: "Failed", error: "Invalid JSON: #{e.message}" }
      nil
    end

    def process_restaurant(rest_data)
      restaurant = Restaurant.find_or_create_by!(name: rest_data["name"]) do |r|
        r.location   = rest_data["location"] || ""
        r.categories = rest_data["categories"] || []
      end

      (rest_data["menus"] || []).each do |menu_data|
        process_menu(restaurant, menu_data)
      end
    rescue ActiveRecord::RecordInvalid => e
      @logs << { restaurant: rest_data["name"], status: "Failed", error: e.message }
    end

    def process_menu(restaurant, menu_data)
      menu = restaurant.menus.find_or_create_by!(name: menu_data["name"]) do |m|
        m.description = menu_data["description"] || ""
      end

      items = menu_data["menu_items"] || menu_data["dishes"] || []
      items.each do |item_data|
        process_menu_item(menu, item_data)
      end
    rescue ActiveRecord::RecordInvalid => e
      @logs << { restaurant: restaurant.name, menu: menu_data["name"], status: "Failed", error: e.message }
    end

    def process_menu_item(menu, item_data)
      menu_item = MenuItem.find_or_create_by!(name: item_data["name"]) do |mi|
        mi.description = item_data["description"] || ""
      end

      # Join association with price for menu_item, allowing the same MenuItem to be used in different Menus with unique prices.
      association = menu.menu_menu_items.create!(menu_item: menu_item, price: item_data["price"])
      @logs << {
        restaurant: menu.restaurant.name,
        menu: menu.name,
        menu_item: menu_item.name,
        price: association.price,
        status: "Success"
      }
    rescue StandardError => e
      @logs << {
        restaurant: menu.restaurant.name,
        menu: menu.name,
        menu_item: item_data["name"],
        price: item_data["price"],
        status: "Failed",
        error: e.message
      }
    end
end
