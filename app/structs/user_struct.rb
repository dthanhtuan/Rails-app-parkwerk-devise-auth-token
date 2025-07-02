require 'dry-validation'
require 'dry/monads'
require 'dry/monads/do'

class UserStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :name, Types::String
  # age is coercible to Integer, but optional (e.g., from string "125" to 12)
  attribute :age, Types::Coercible::Integer.optional
  attribute :credits, Types::Integer.default(0)
  attribute :email, Types::String.optional.default(nil)
  attribute :address, Types::Hash.optional.default({})

  # Sample: user = UserStruct.new(name: 'test', age: 14,
  #   address: {street: 'stress_name', city: 'city_name', state: 'state_name', zip_code: '12345'}
  # )
  def save
    contract = Contracts::UserContract.new.call(self.to_h)
    if contract.success?
      puts "User saved successfully: #{self.to_h}"
    else
      puts "Validation errors: #{contract.errors.to_h}"
      raise Dry::Struct::Error, contract.errors.to_h
    end
  end
end
