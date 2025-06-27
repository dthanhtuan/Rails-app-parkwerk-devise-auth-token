module Users
  class ConfirmationCodeMailer < UserBaseMailer
    def confirmation_code_email(user_email, confirmation_token)
      Rails.logger.info "Mailer view paths: #{view_paths.inspect}"
      @user_email = user_email
      @confirmation_token = confirmation_token
      mail(to: user_email, subject: 'Your Registration Confirmation Code')
    end
  end
end
