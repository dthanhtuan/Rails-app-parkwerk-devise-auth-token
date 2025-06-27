namespace :users do
  post "confirm_registration", to: "confirmations#confirm_registration"
end
