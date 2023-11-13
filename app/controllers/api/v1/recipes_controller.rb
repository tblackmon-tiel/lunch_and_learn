class Api::V1::RecipesController < ApplicationController
  def index
    if params[:country] == ""
      render json: {data: []}
    else
      recipes = RecipesFacade.new(params[:country]).recipes
      render json: RecipeSerializer.new(recipes)
    end
  end
end