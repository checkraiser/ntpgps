module ExtractTokener
  def self.call(request, session)
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
end