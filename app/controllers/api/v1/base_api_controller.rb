module Api
  module V1
    class BaseApiController < Api::BaseController
      # 原則ログイン必須（index/show など公開APIは各Controllerで skip）
      before_action :authenticate_user!

      private

      # ★ 仮の current_user 実装
      #  - まず Devise(または devise_token_auth) が返す current_user を優先
      #  - それが無い/空なら、開発・テスト環境では User.first を仮ユーザーとして返す
      #  - 本番で未ログインなら nil
      def current_user
        # Devise 側の current_user があれば優先
        if defined?(super)
          cu = super
          return cu if cu.present?
        end

        # 開発/テストでは仮ユーザー
        return User.first if Rails.env.development? || Rails.env.test?

        # 本番は未ログイン扱い
        nil
      end

      # ★ 認証フィルタ
      #  - current_user がいなければ 401 をJSONで返す
      #  - 将来 Devise の authenticate_user! を使う場合は、ここから super を呼ぶ形に差し替えてOK
      def authenticate_user!
        return if current_user.present?

        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
