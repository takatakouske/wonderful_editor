module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        # CSRF を確実に無効化（このクラス配下）
        skip_forgery_protection
        respond_to :json

        # どのクラスが実行されているか可視化（先頭で出す）
        before_action :_probe, prepend: true

        private

        def _probe
          Rails.logger.info ">>> HIT #{self.class} < #{self.class.superclass}"
        end

        def sign_up_params
          params.permit(:email, :password, :password_confirmation, :name)
        end

        def account_update_params
          params.permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
