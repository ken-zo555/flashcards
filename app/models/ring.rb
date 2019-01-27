class Ring < ApplicationRecord
  belongs_to :user
  has_many :card_ring_links, dependent: :destroy
  has_many :cards, through: :card_ring_links, source: :card
  has_many :check_logs, dependent: :destroy

  validates :user_id, presence: true
  validates :ring_name, presence: true, length: { maximum: 255 }

  def self.search(search) #ここでのself.はRing.を意味する
    if search
      Ring.where(['ring_name LIKE ?', "%#{search}%"]) #検索とring_nameの部分一致を表示。Ring.は省略可能
    else
      Ring.all #全て表示。Ring.は省略可能
    end
  end

end
