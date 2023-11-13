class Api::V1::RecipesController < ApplicationController
  def index
    recipes = RecipesFacade.new(params[:country]).recipes
  end
end