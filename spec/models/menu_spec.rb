require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_menu_items).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_menu_items) }
  end

  describe 'validations' do
    subject { build(:menu) }

    it { should validate_presence_of(:name) }
  end
end
