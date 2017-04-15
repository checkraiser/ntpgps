require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should extract access_token" do 
  	header 'access_token', 'hihihi'
  	post_json('/test', {'key' => "value"}.to_json)
  	puts last_response.body
  end


  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json" })
  end
end