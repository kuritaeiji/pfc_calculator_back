class Api::V1::UsersController < ApplicationController
  def index
    render(json: 'Hello, World')
  end
end
