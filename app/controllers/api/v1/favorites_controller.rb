class Api::V1::FavoritesController < ApplicationController
  def create
    parsed_request = JSON.parse(request.body.read, symbolize_names: true)

    user = User.find_by(api_key: parsed_request[:api_key])
    if !user
      render json: {errors: "Invalid API key"}, status: 401
      break
    end

    favorite = Favorite.new(
      user_id: user.id,
      country: parsed_request[:country],
      recipe_link: parsed_request[:recipe_link],
      recipe_title: parsed_request[:recipe_title]
    )

    if favorite.save
      render json: {success: "Favorite added successfully"}
    else
      render json: {errors: favorite.errors.full_messages.to_sentence}, status: 400
    end
  end

  def index

  end
end