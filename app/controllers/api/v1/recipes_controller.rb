class Api::V1::RecipesController < ApplicationController
  def index
    recipes = RecipesFacade.new(params[:country]).recipes
    render json: RecipesSerializer.new(recipes)
  end
end