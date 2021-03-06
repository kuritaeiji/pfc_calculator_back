module Request
  module Helpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def status
      @status ||= response.status
    end

    def login_header(user)
      { Authorization: "Bearer #{user.create_token}" }
    end
  end
end
