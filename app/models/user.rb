# app/models/user.rb
# frozen_string_literal: true

class User < ApplicationRecord
  # Devise の有効化モジュール（必要に応じて調整）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # devise_token_auth の必須 mixin
  include DeviseTokenAuth::Concerns::User
end
