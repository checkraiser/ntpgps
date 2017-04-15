module AuthHelper
  # helper to extract the token from the session, header or request param
  # if we are building an api, we would obviously want to handle header or request param
  def extract_token(request)
    # check for the access_token header
    token = request.env["access_token"]
    
    if token
      return token
    end

    # or the form parameter _access_token
    token = request["access_token"]

    if token
      return token
    end

    # or check the session for the access_token
    token = session["access_token"]

    if token
      return token
    end

    return nil
  end

  # check the token to make sure it is valid with our public key
  def authorized?(request, settings)
    token = extract_token(request)
    begin
      payload, header = JWT.decode(token, settings.verify_key, true)
      
      exp = header["exp"]

      # check to see if the exp is set (we don't accept forever tokens)
      if exp.nil?
        puts "Access token doesn't have exp set"
        return false
      end

      exp = Time.at(exp.to_i)

      # make sure the token hasn't expired
      if Time.now > exp
        puts "Access token expired"
        return false
      end

      yield payload["user_id"]

    rescue JWT::DecodeError => e
      return false
    end
  end
end