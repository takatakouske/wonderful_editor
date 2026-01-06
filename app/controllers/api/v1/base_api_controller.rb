module Api
  module V1
    class BaseApiController < Api::BaseController
      # Devise Token Auth のトークン判定を有効化
      include DeviseTokenAuth::Concerns::SetUserByToken

      # APIはCSRFセッションを使わない
      protect_from_forgery with: :null_session

      private

      # DTAが生やす名前空間付きメソッドを、共通の名前に寄せる
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
