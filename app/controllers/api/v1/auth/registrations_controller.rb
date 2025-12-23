module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        skip_forgery_protection
        respond_to :json

        before_action do
          Rails.logger.info ">>> HIT #{self.class} < #{self.class.superclass} | ancestors: #{self.class.ancestors.take(5)}"
        end

        private

        def sign_up_params
          params.permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
