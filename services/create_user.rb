require_relative "base_service"

class CreateUser < BaseService
  property :name, required: true
  property :email, required: :email?
  property :password, required: :min_lenght?

  private

  def email?
  	true
  end

  def min_length?
  	true
  end

  def execute!
  	User.create! email: email,
  				 name: name,
  				 password: password
  end
end