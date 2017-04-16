require_relative 'transactional'

class BaseService < Hashie::Dash 
  include Transactional

  def initialize(params)
  	super
  rescue => e 
  	return { errors: e.message }
  end
end