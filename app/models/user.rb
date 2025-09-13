# app/models/user.rb
# frozen_string_literal: true

class User < ApplicationRecord
  # Devise の有効化モジュール（必要に応じて調整）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # devise_token_auth の必須 mixin
  include DeviseTokenAuth::Concerns::User

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy
  has_many :liked_articles, through: :likes, source: :article
end
