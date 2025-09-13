class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  presence: true, length: { maximum: 10_000 }
end
