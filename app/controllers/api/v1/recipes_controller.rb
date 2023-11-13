class Api::V1::RecipesController < ApplicationController
  def index
    if params[:country] == ""
      render json: {data: []}
    elsif params[:country].present?
      recipes = RecipesFacade.new(params[:country]).recipes
      render json: RecipeSerializer.new(recipes)
    else
      recipes = RecipesFacade.new.recipes
      render json: RecipeSerializer.new(recipes)
    end
  end
end