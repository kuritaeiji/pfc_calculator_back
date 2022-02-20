class ApplicationController < ActionController::API
  include(Authenticator)
end
