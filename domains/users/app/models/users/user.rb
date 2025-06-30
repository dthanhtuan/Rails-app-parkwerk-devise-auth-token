module Users
  class User < ApplicationRecord
    extend Devise::Models
    include DeviseTokenAuth::Concerns::User

    CONFIRMATION_CODE_EXPIRATION_PERIOD = 10.minutes

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :confirmable

    # Validations
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

    before_validation do
      self.uid = email if uid.blank?
    end

    def send_confirmation_instructions(_opts = {})
      return unless can_resend_confirmation_code_email?

      self.confirmation_code = SecureRandom.hex(6).upcase
      self.confirmation_code_sent_at = Time.zone.now
      save(validate: false)
      Users::ConfirmationCodeMailer.confirmation_code_email(self.email, self.confirmation_code).deliver_later
    end

    def confirmation_code_valid?(confirmation_code)
      return false if confirmation_code.blank?
      return false if confirmation_code_sent_at.nil? || confirmation_code_sent_at < CONFIRMATION_CODE_EXPIRATION_PERIOD.ago

      self.confirmation_code == confirmation_code
    end

    def confirm_by_code!(confirmation_code)
      return false unless confirmation_code_valid?(confirmation_code)

      update!(
        confirmed_at: Time.zone.now,
        confirmation_code: nil,
        confirmation_code_sent_at: nil
      )
      confirm
      true
    rescue StandardError => e
      Rails.logger.error("Failed to confirm user by code: #{e.message}")
    end

    private

    def can_resend_confirmation_code_email?
      return true if self.confirmation_code_sent_at.nil?
      self.confirmation_code_sent_at < CONFIRMATION_CODE_EXPIRATION_PERIOD.ago
    end
  end
end
