class Card < ApplicationRecord
  belongs_to :user
  has_many :card_ring_links, dependent: :destroy 
  has_many :rings, through: :card_ring_links, source: :ring

  validates :user_id, presence: true
  validates :content_1, length: { maximum: 255 }
  validates :content_2, length: { maximum: 255 }
  
  def add_to_ring(ring)
    self.card_ring_links.find_or_create_by(ring_id: ring.id)
  end

  def remove_from_ring(ring)
    card_ring_link = self.card_ring_links.find_by(ring_id: ring.id)
    card_ring_link.destroy if card_ring_link
  end

  def is_ring?(ring)
    self.rings.include?(ring)
  end

end
