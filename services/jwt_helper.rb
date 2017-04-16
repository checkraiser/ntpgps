module JwtHelper
  # check the token to make sure it is valid with our public key
  def self.decode(token)
    begin
      verify_key = JwtHelper.keys[:verify_key]
      payload, header = JWT.decode(token, verify_key, true)
      
      exp = header["exp"]

      # check to see if the exp is set (we don't accept forever tokens)
      if exp.nil?
        return {error: "Access token doesn't have exp set"}
      end

      exp = Time.at(exp.to_i)

      # make sure the token hasn't expired
      if Time.now > exp
        return {error: "Access token expired"}
      end

      return {success: payload["user_id"]}

    rescue JWT::DecodeError => e
      return {error: "Decode error"}
    end
  end

  def self.encode(user_id)
    signing_key = JwtHelper.keys[:signing_key]
    headers = {
      exp: Time.now.to_i + 20 #expire in 20 seconds
    }

    JWT.encode({user_id: user_id}, signing_key, "RS256", headers)
  end

  def self.keys
    signing_key_path = File.expand_path("../../config/secrets/app.rsa", __FILE__)
    verify_key_path = File.expand_path("../../config/secrets/app.rsa.pub", __FILE__)

    signing_key = ""
    verify_key = ""

    File.open(signing_key_path) do |file|
      signing_key = OpenSSL::PKey.read(file)
    end

    File.open(verify_key_path) do |file|
      verify_key = OpenSSL::PKey.read(file)
    end
    {signing_key: signing_key, verify_key: verify_key}
  end
end