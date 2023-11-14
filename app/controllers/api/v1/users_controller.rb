require 'securerandom'

class Api::V1::UsersController < ApplicationController

  def create
    if !request.body.read.empty?
      data = JSON.parse(request.body.read, symbolize_names: true)
      
      user = User.new(
        name: data[:name],
        email: data[:email],
        password: data[:password],
        password_confirmation: data[:password_confirmation],
        api_key: SecureRandom.urlsafe_base64
      )

      if user.save
        render json: UserSerializer.new(user)
      else
        render json: {errors: user.errors.full_messages.to_sentence}, status: 400
      end
    else
      render json: {errors: "Please send registration in the request body."}, status: 400
    end
  end
end