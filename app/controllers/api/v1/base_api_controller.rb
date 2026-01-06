module Api
  module V1
    class BaseApiController < Api::BaseController
      # devise_token_auth が提供する SetUserByToken を全APIで有効化
      include DeviseTokenAuth::Concerns::SetUserByToken

      # 原則ログイン必須（公開APIは各Controllerで skip する）
      before_action :authenticate_user!

      private

      # devise_token_auth はスコープ単位のcurrent_xxxを返す
      # current_api_v1_user を current_user という名前で扱えるようにエイリアス化
      def current_user
        current_api_v1_user
      end

      # サインイン状態の判定もAPIスコープ版を利用
      def user_signed_in?
        api_v1_user_signed_in?
      end

      # 未ログインなら401で弾く
      def authenticate_user!
        return if user_signed_in?

        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
