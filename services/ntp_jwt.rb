module NtpJwt
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