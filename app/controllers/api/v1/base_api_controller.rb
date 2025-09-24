module Api
  module V1
    class BaseApiController < Api::BaseController
      before_action :authenticate_user!

      # ★ 仮の current_user 実装：
      #  - 本来は devise_token_auth の current_user を使う
      #  - まだトークンが無い時は（開発/テスト環境だけ）User.first を返す
      def current_user
        # Devise の current_user がいればそれを優先
        if defined?(super)
          candidate = super
          return candidate if candidate.present?
        end

        # 開発/テスト時の仮ユーザー（最初のユーザー）
        return User.first if Rails.env.development? || Rails.env.test?

        # 本番で未ログインなら nil（authenticate_user! が 401 にする）
        nil
      end
    end
  end
end
