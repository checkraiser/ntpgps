require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  validates_presence_of :name
  validates_presence_of :email

  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end
end