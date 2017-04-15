module JsonHelper
  def self.parse_json(request)
	JSON.parse(request.body.read)
  end

  def self.render(object)
  	object.as_json
  end
end