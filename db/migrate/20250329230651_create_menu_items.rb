class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.text :category
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
