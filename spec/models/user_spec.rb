require File.expand_path '../../spec_helper.rb', __FILE__
require 'bcrypt'

describe "User", type: :model do
  it "should create new user" do
    user = create(:user)
    expect(user.password == "123456").to be_truthy
  end
end