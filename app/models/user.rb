class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cards, dependent: :destroy
  has_many :rings, dependent: :destroy
  has_many :check_logs, dependent: :destroy
  
  validates :name, length: { maximum: 50 }
  
end
