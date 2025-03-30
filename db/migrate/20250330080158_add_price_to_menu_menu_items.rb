class AddPriceToMenuMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_menu_items, :price, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end
