class Api::V1::FavoritesController < ApplicationController
  def create
    if request.body.read.empty?
      render json: {errors: "Please send data in the request body"}, status: 400
      return
    end

    facade = FavoritesCreateFacade.new(request.body.read)

    if !facade.user
      render json: {errors: "Invalid API key"}, status: 401
    elsif facade.new_favorite.save
      render json: {success: "Favorite added successfully"}
    else
      render json: {errors: facade.new_favorite.errors.full_messages.to_sentence}, status: 400
    end
  end

  def index
    user = User.find_by(api_key: params[:api_key])

    if user
      render json: FavoriteSerializer.new(user.favorites)
    else
      render json: {errors: "Invalid API key"}, status: 401
    end
  end
end