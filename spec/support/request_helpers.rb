module Request
  module Helpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def status
      @status ||= response.status
    end
  end
end
