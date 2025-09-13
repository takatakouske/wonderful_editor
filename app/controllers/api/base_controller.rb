module Api
  class BaseController < ApplicationController
    # APIはトークン認証前提なのでCSRFを無効化
    skip_forgery_protection

    # 全APIをJSONに固定（routes.rbに defaults: { format: :json } も併用推奨）
    before_action :force_json_format

    # ここに「API横断の共通ふるまい」を集約
    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: 'Not Found' }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end

    private

    def force_json_format
      request.format = :json
    end

    # 422の共通レスポンス整形
    def render_unprocessable!(record)
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
