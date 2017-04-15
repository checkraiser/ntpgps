module JsonHelper
  def self.parse_json(request)
	JSON.parse(request.env["rack.input"].read)
  end
end