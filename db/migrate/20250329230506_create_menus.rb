class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :description
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
