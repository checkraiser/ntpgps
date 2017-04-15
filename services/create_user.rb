class CreateUser
  attr_reader :params

  def initialize(params)
  	@params = params
  	validate! params
  end

  def call
  	guard!
  	execute!
  end

  private

  def validate!
  	true
  end

  def guard!
  	true
  end

  def execute!
  	true
  end
end