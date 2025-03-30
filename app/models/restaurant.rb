class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy

  validates :name, presence: true
  # validates :categories, presence: true

  # validate :must_have_at_least_one_category

  private

#   def must_have_at_least_one_category
#     if categories.blank? || categories.reject(&:blank?).empty?
#       errors.add(:categories, "restaurant must have at least one category")
#     end
#   end
end
