class CheckLog < ApplicationRecord
  belongs_to :user
  belongs_to :ring
  has_many :check_cards, dependent: :destroy
end
