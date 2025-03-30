class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :location
      t.string :categories, array: true, default: []
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
