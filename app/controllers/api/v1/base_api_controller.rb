module Api
  module V1
    class BaseApiController < Api::BaseController
      # トークンからユーザーを特定する devise_token_auth の仕組みを有効化
      include DeviseTokenAuth::Concerns::SetUserByToken

      # 以降は devise_token_auth がスコープ付きで提供するメソッドへ委譲
      # mount_devise_token_auth_for を api/v1 にマウントしているので
      # ヘルパは current_api_v1_user / authenticate_api_v1_user! / api_v1_user_signed_in?
      def current_user
        current_api_v1_user
      end

      def authenticate_user!
        authenticate_api_v1_user!
      end

      def user_signed_in?
        api_v1_user_signed_in?
      end
    end
  end
end
