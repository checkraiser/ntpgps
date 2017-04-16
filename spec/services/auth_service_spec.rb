require File.expand_path '../../spec_helper.rb', __FILE__

describe 'Auth service' do 
  it 'create token' do 
  	user = create(:user)
  	token = JwtHelper.encode(user.id)
  	payload = JwtHelper.decode(token)
  	expect(payload[:success]).to eql(user.id)
  end
end