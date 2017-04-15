require_relative 'transactional'

class CreateUser
  include Transactional
  attr_reader :params

  def initialize(params)
  	@params = params
  	validate! params
  end

  def call
  	with_db do 
  	  guard!  	
  	  execute!
  	end
  end

  private

  def validate!
  	true
  end

  def guard!
  	true
  end

  def execute!
  	User.create email: params["email"],
  				name: params["name"],
  				password: params["password"]
  end
end