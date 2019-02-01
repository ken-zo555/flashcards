class CheckLog < ApplicationRecord
  belongs_to :user
  belongs_to :ring
  has_many :check_cards, dependent: :destroy

  def self.search(search) #ここでのself.はCheckLog.を意味する
    if search
      CheckLog.joins(:ring).where(['ring_name LIKE ?', "%#{search}%"]) #検索とring_nameの部分一致を表示。CheckLog.は省略可
    else
      CheckLog.all #全て表示。CheckLog.は省略可
    end
  end

end
