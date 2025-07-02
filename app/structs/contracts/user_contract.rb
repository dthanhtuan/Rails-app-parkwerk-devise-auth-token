module Contracts
  class UserContract < Dry::Validation::Contract
    params do
      required(:name).filled(:string)
      optional(:age).maybe(:integer)
      optional(:credits).filled(:integer)
      optional(:email).maybe(:string)
      required(:address).hash do
        required(:street).filled(:string)
        required(:city).filled(:string)
        required(:state).filled(:string)
        required(:zip_code).filled(:string)
      end
    end
  end
end
