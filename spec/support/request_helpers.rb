module Request
  module Helpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def status
      @status ||= response.status
    end

    def login_header(user)
      { headers: { Authorization: user.create_token } }
    end
  end
end
