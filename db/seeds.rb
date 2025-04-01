require 'faker'
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "Clearing existing records..."
MenuMenuItem.destroy_all
Menu.destroy_all
MenuItem.destroy_all
Restaurant.destroy_all

puts "Seeding Restaurants, Menus, Menu Items, and Associations..."

5.times do
  restaurant = create(:restaurant)
  puts "Created Restaurant: #{restaurant.name}"

  2.times do
    menu = create(:menu, restaurant: restaurant)
    puts "  Created Menu: #{menu.name}"

    3.times do
      menu_item = create(:menu_item)
      price = Faker::Commerce.price(range: 5.0..50.0)
      create(:menu_menu_item, menu: menu, menu_item: menu_item, price: price)
      puts "    Associated Menu Item: #{menu_item.name} at $#{price}"
    end
  end
end

puts "Seeding done!"
puts "Restaurants: #{Restaurant.count}, Menus: #{Menu.count}, Menu Items: #{MenuItem.count}, Associations: #{MenuMenuItem.count}"
