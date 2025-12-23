class ApplicationController < ActionController::Base
  # JSON リクエストは CSRF を検証しない（Postman などの外部クライアント向け）
  skip_before_action :verify_authenticity_token,
                     if: -> { request.format.json? || request.content_type == "application/json" }

  # 万一検証に入っても例外にせずセッションを空にする
  protect_from_forgery with: :null_session
end
