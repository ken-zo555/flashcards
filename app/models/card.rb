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

  def self.search(search) #ここでのself.はCard.を意味する
    if search
      Card.where(['content_1 LIKE ? or content_2 LIKE ?', "%#{search}%", "%#{search}%"]) #検索とring_nameの部分一致を表示。Card.は省略可能
    else
      Card.all #全て表示。Card.は省略可能
    end
  end

end
