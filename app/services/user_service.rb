class UserService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:create_user)

  def create_user(params)
    validated = yield validate_params(params)
    user = yield persist_user(validated)
    Success(user)
  end

  private

  def validate_params(params)
    contract = Contracts::UserContract.new.call(params)
    if contract.success?
      Success(contract.to_h)
    else
      Failure(contract.errors.to_h)
    end
  end

  def persist_user(validated_params)
    begin
      user = ::UserStruct.new(validated_params)
      Success(user)
    rescue => e
      Failure(e.message)
    end
  end
end

# Example usage:
# service = UserService.new
# result = service.create_user(name: 'test', age: 14, address: {street: 'street', city: 'city', state: 'state', zip_code: '12345'})
# result.fmap { |user| puts "User created: #{user.to_h}" }
# result.or { |err| puts "Error: #{err}" }
