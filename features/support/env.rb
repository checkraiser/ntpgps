ENV['RACK_ENV'] = 'test'
require_relative '../../app'
require 'spinach/capybara'
require 'minitest/spec'
require 'rack/test'
# database cleaner
require_relative '../../spec/spec_helper'
require_relative '../steps/common/helper'

Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)


Spinach.hooks.before_scenario do
  DatabaseCleaner.clean
end

class Spinach::FeatureSteps
  include Rack::Test::Methods
  include ::FactoryGirl::Syntax::Methods
  include RSpec::Matchers
  include Common::Helper
end