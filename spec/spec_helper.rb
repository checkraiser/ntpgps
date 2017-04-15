require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'faker'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__
ActiveRecord::Migration.maintain_test_schema!

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end
FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}

# For RSpec 2.x and 3.x
RSpec.configure { |c| 	
	c.include RSpecMixin 
	c.include FactoryGirl::Syntax::Methods
	c.before(:suite) do 
	  FactoryGirl.find_definitions       
	end
}
