class Ring < ApplicationRecord
  belongs_to :user
  has_many :card_ring_links, dependent: :destroy
  has_many :cards, through: :card_ring_links, source: :card
  has_many :check_logs, dependent: :destroy

  validates :user_id, presence: true
  validates :ring_name, presence: true, length: { maximum: 255 }

end
