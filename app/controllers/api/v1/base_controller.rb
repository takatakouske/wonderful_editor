module Api
  module V1
    class BaseController < ApplicationController
      # API ではCSRFを無効化（トークンヘッダで認証するため）
      skip_forgery_protection

      # devise_token_auth（全エンドポイントを原則ログイン必須に）
      before_action :authenticate_user!

      # 存在しないIDなど
      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: 'Not Found' }, status: :not_found
      end

      # 必須パラメータ不足など
      rescue_from ActionController::ParameterMissing do |e|
        render json: { error: e.message }, status: :bad_request
      end

      private

      # 共通：422の整形
      def render_unprocessable!(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
