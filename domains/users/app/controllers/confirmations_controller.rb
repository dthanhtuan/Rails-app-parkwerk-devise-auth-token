class ConfirmationsController < ApplicationController
  def confirm_registration
    user = User.find_by(email: params[:email])

    if user.blank?
      render json: { error: 'User not found' }, status: :not_found and return
    end

    if user.confirmed?
      render json: { message: 'User already confirmed' }, status: :ok and return
    end

    confirmation_code = params[:confirmation_code]
    if user.present? && user.confirm_by_code!(confirmation_code)
      render json: { message: 'Registration confirmed successfully' }, status: :ok
    else
      render json: { error: 'Invalid or expired confirmation code' }, status: :unprocessable_entity
    end
  end
end
