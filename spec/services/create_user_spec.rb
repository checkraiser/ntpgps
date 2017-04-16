require File.expand_path '../../spec_helper.rb', __FILE__

describe 'Create user' do 
  let(:email) { 'dungth1@hpu.edu.vn' }
  let(:password) { '123456789' }
  let(:name_errors) { {:errors=>"Validation failed: Name can't be blank"} }
  it 'does not create user without name ' do   	
  	params = { email: email, password: password }
  	cu = CreateUser.new(params)
  	expect(cu.call).to eql(name_errors)
  end
end