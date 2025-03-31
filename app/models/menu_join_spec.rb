require "rails_helper"

RSpec.describe "Menu and MenuItem integration", type: :model do
  let!(:restaurant) { Restaurant.create(name: "Test Restaurant", location: "Test Location", categories: [ "Mexican" ]) }
  let!(:menu1) { restaurant.menus.create(name: "Lunch Menu", description: "Lunch Rush") }
  let!(:menu2) { restaurant.menus.create(name: "Dinner Menu", description: "Evening specials") }
  let!(:menu_item) { MenuItem.create(name: "Taco", description: "Spicy beef taco") }

  it "associates a menu item with a menu" do
    menu1.menu_menu_items.create!(menu_item: menu_item, price: 3.50)
    expect(menu1.menu_items).to include(menu_item)
    association = menu1.menu_menu_items.find_by(menu_item: menu_item)
    expect(association.price).to eq(3.50)
  end

  it "allows a menu item to belong to multiple menus with different prices" do
    menu1.menu_menu_items.create!(menu_item: menu_item, price: 3.50)
    menu2.menu_menu_items.create!(menu_item: menu_item, price: 4.00)
    menu1.menu_items << menu_item
    menu2.menu_items << menu_item
    expect(menu1.menu_menu_items.find_by(menu_item: menu_item).price).to eq(3.50)
    expect(menu2.menu_menu_items.find_by(menu_item: menu_item).price).to eq(4.00)
  end

  it "prevents duplicate associations between the same menu and menu item" do
    menu1.menu_items << menu_item
    expect {
      menu1.menu_menu_items.create!(menu_item: menu_item)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
