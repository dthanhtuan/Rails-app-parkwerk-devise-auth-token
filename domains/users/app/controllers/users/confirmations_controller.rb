module Users
  class ConfirmationsController < ApplicationController
    COOL_DOWN_PERIOD = 10.minutes

    def confirm_registration
      user = find_user_by_email
      if user_not_found?(user)
        render json: { error: 'User not found' }, status: :not_found and return
      end
      if user_already_confirmed?(user)
        render json: { message: 'User already confirmed' }, status: :ok and return
      end
      confirmation_code = params[:confirmation_code]
      if user.confirm_by_code!(confirmation_code)
        render json: { message: 'Registration confirmed successfully' }, status: :ok
      else
        render json: { error: 'Invalid or expired confirmation code' }, status: :unprocessable_entity
      end
    end

    def create
      user = find_user_by_email
      if user_not_found?(user)
        render json: { error: 'User not found' }, status: :not_found and return
      end
      if user_already_confirmed?(user)
        render json: { message: 'User already confirmed' }, status: :ok and return
      end
      if violate_cooldown_period?(user)
        time_left = ((user.confirmation_sent_at + COOL_DOWN_PERIOD) - Time.current).ceil
        render json: { error: "Please wait #{time_left} seconds before requesting again." }, status: :too_many_requests and return
      end
      user.send_confirmation_instructions
      render json: { message: 'Confirmation instructions resent.' }, status: :ok
    end

    private

    def find_user_by_email
      User.find_by(email: params[:email])
    end

    def user_not_found?(user)
      user.nil?
    end

    def user_already_confirmed?(user)
      user.confirmed?
    end

    def violate_cooldown_period?(user)
      user.confirmation_sent_at.present? && user.confirmation_sent_at > COOL_DOWN_PERIOD.ago
    end
  end
end
