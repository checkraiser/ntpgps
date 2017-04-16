module Common  
  module Helper
    delegate :headers, to: :last_response

    def json_body
      last_response.body
    end

    def parsed_body
      JSON.parse(json_body, symbolize_names: true)
    end

    def json_encode(json_hash)
      ActiveSupport::JSON.encode(json_hash)
    end

    def app
      Capybara.app ||= Sinatra::Application
    end

    def http_status
      last_response.status
    end

    def json_datetime_format(datetime)
      datetime.to_formatted_s(:iso8601) if datetime
    end

    def body_ids
      parsed_body.map { |obj| obj['id'] }
    end
  end
end