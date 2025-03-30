class RemovePriceFromMenuItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :menu_items, :price, :decimal
  end
end
