# app/models/user.rb
# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  # 必要なDeviseモジュールだけ有効化
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
        #  :confirmable   # ← メール確認を使わないならこの1行は外してOK

  include DeviseTokenAuth::Concerns::User
end
