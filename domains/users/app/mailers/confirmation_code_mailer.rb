class ConfirmationCodeMailer < UserBaseMailer
  def confirmation_code_email(user_email, confirmation_token)
    @user_email = user_email
    @confirmation_token = confirmation_token
    mail(to: user_email, subject: 'Your Registration Confirmation Code')
  end
end
