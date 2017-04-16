require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'faker'
require 'database_cleaner'
require 'timecop'

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
	DatabaseCleaner.strategy = :truncation

  c.before(:suite) do
    begin
      DatabaseCleaner.clean_with(:truncation)
      DatabaseCleaner.start
      FactoryGirl.lint traits: true
    ensure
      DatabaseCleaner.clean_with(:truncation)
    end
  end

  c.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  c.around(:each, freeze: true) do |example|
    time = example.metadata.fetch(:freeze)
    Timecop.freeze(time.eql?(true) ? Date.current : time) do
      example.run
    end
  end
}
