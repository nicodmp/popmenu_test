require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should have_many(:menu_menu_items).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_menu_items) }
  end

  describe 'validations' do
    subject { MenuItem.create(name: 'Unique Dish', description: 'Unique test dish') }
    
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
