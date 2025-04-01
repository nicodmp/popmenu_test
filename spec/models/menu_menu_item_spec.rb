require 'rails_helper'

RSpec.describe MenuMenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu) }
    it { should belong_to(:menu_item) }
  end

  describe 'validations' do
    subject { create(:menu_menu_item) }

    it { should validate_uniqueness_of(:menu_item_id).scoped_to(:menu_id) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end
end
