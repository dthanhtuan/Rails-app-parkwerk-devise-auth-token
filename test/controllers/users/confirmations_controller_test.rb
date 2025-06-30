require 'test_helper'

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = Users::User.create!(email: 'test@example.com', password: 'password', confirmation_code: '123456', confirmation_sent_at: 15.minutes.ago)
    @user.update_column(:confirmation_code, '123456')
  end

  test 'returns not found if user does not exist' do
    post verify_email_path, params: { email: 'notfound@example.com', confirmation_code: '123456' }
    assert_response :not_found
    assert_includes @response.body, 'User not found'
  end

  test 'returns already confirmed if user is confirmed' do
    @user.update!(confirmed_at: Time.current)
    post verify_email_path, params: { email: @user.email, confirmation_code: '123456' }
    assert_response :ok
    assert_includes @response.body, 'already confirmed'
  end

  test 'confirms registration with valid code' do
    post verify_email_path, params: { email: @user.email, confirmation_code: '123456' }
    assert_response :ok
    assert_includes @response.body, 'Registration confirmed successfully'
  end

  test 'returns error for invalid code' do
    post verify_email_path, params: { email: @user.email, confirmation_code: 'wrong' }
    assert_response :unprocessable_entity
    assert_includes @response.body, 'Invalid or expired confirmation code'
  end

  test 'returns not found if user does not exist (resend confirmation)' do
    post resend_confirmation_instructions_path, params: { email: 'notfound@example.com' }
    assert_response :not_found
    assert_includes @response.body, 'User not found'
  end

  test 'returns already confirmed if user is confirmed (resend confirmation)' do
    @user.update!(confirmed_at: Time.current)
    post resend_confirmation_instructions_path, params: { email: @user.email }
    assert_response :ok
    assert_includes @response.body, 'already confirmed'
  end

  test 'returns cooldown error if within cooldown period' do
    @user.update!(confirmation_sent_at: 5.minutes.ago)
    post resend_confirmation_instructions_path, params: { email: @user.email }
    assert_response :too_many_requests
    assert_includes @response.body, 'Please wait'
  end

  test 'resends confirmation if outside cooldown period' do
    @user.update!(confirmation_sent_at: 15.minutes.ago)
    post resend_confirmation_instructions_path, params: { email: @user.email }
    assert_response :ok
    assert_includes @response.body, 'Confirmation instructions resent.'
  end
end
