class Api::V1::SessionsController < ApplicationController
  def create
    if !request.body.read.empty?
      user_auth = JSON.parse(request.body.read, symbolize_names: true)
      user = User.find_by(email: user_auth[:email])

      if user && user.authenticate(user_auth[:password])
        render json: UserSerializer.new(user)
      elsif user_auth[:password] && user_auth[:email]
        render json: {errors: "Could not authenticate: invalid email or password"}, status: 400
      else
        render json: {errors: "Request is missing email and/or password"}, status: 400
      end
    else
      render json: {errors: "Please send authentication in the request body."}, status: 400
    end
  end
end