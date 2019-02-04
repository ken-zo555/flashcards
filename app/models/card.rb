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
  
  def self.search_b(ring,search)
    if search != nil then
      if ring == "(ALL)" || ring == nil || ring == '' then
        self.where(['content_1 LIKE ? or content_2 LIKE ?', "%#{search}%", "%#{search}%"])
      else
        self.joins(:rings).where(['ring_id = ? ', ring ]).where(['content_1 LIKE ? or content_2 LIKE ?', "%#{search}%", "%#{search}%"]) #検索とring_nameの部分一致を表示。Card.は省略可能
      end
    else
      if ring == "(ALL)" || ring == nil || ring == '' then
        Card.all  #全て表示。Card.は省略可能
      else
        self.joins(:rings).where(['ring_id = ? ', ring ])
      end
    end
  end

  def self.import_format_a(file) # ヘッダーあり、user_id,content_1,content_2
    CSV.foreach(file.path, headers: true) do |row|
      obj = new
      obj.attributes = row.to_hash.slice(*updatable_attributes_a)
      obj.save!
    end
  end
  
  def self.updatable_attributes_a
    ["user_id","content_1","content_2"]
  end

  def self.import_format_b(file,user) # ヘッダーなし、content_1,content_2
    CSV.foreach(file.path, headers: false) do |row|
      obj = new
      hs = { :user_id => user.id, :content_1 => "#{row[0]}", :content_2 => "#{row[1]}"}
      obj.attributes = hs
      obj.save!
    end
  end
  
end

