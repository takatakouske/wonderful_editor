# app/models/article.rb
class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  presence: true, length: { maximum: 10_000 }

  # enum 定義（デフォルトは draft）
  enum status: { draft: 0, published: 1 }, _default: :draft
end
