Rails.application.routes.draw do
  get "home/index"
  mount_devise_token_auth_for "Users::User", at: "auth", skip: [:sessions, :registrations, :passwords, :confirmations, :omniauth_callbacks]

  devise_scope :users_user do
    post '/register', to: 'devise_token_auth/registrations#create', as: :user_registration
    post '/sign_in', to: 'devise_token_auth/sessions#create', as: :register
    delete '/sign_out', to: 'devise_token_auth/sessions#destroy', as: :destroy_user_session
    post '/verify-email', to: 'users/confirmations#confirm_registration', as: :confirm_registration
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "rails/welcome#index"

  draw :users
  draw :vouchers

  resources :home, only: [ :index ]


  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
