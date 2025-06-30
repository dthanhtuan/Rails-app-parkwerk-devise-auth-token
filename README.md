# Rails App

This is a sample Rails application demonstrating the use of the following gems and features:

## Key Gems

- **Packwerk**: For modularizing and enforcing boundaries between different domains in the application.
- **Devise Token Auth**: For token-based authentication, supporting APIs and single-page applications.

## Features

- **User Registration**: Users can register for an account.
- **Sign In / Sign Out**: Token-based authentication for logging in and out.
- **Email Verification with Code**: After registration, users receive a verification code via email to confirm their account.
- **Resend Confirmation Email**: Users can request a new confirmation email if needed.

## Endpoints

- `POST /register` — Register a new user
- `POST /sign_in` — Sign in with email and password
- `DELETE /sign_out` — Sign out (invalidate token)
- `POST /verify-email` — Verify email with confirmation code
- `POST /resend-confirmation` — Resend confirmation email

## Protected Routes

- The `/vouchers` route is protected by Devise Token Auth. Only authenticated users with a valid token can access this endpoint.

## Project Structure

- Modularized using Packwerk (see `domains/` directory for domain packages)
- Authentication and user management logic is under the `users` domain

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```
2. Run database migrations:
   ```bash
   rails db:migrate
   ```
3. Start the Rails server:
   ```bash
   rails server
   ```

## Notes

- Make sure to configure your mailer settings for email confirmation to work.
- This app is intended as a reference for modular Rails apps with API authentication.
