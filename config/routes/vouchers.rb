resources :vouchers, only: [:index, :show], param: :email do
  collection do
    get 'status/:code', to: 'vouchers/statuses#show'
  end
end

