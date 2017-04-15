require File.expand_path '../../spec_helper.rb', __FILE__

describe "Authentication" do
  it "should allow login" do
    email = 'dungth@hpu.edu.vn'
    password = '12345678'
    user = create(:user, email: email, password: password)
    post_json '/login', { 'email' => email, 'password' => password}.to_json
    expect(last_response).to be_ok
    p last_response.body
  end

  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json" })
  end
end