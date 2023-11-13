class RecipesFacade
  attr_reader :recipes
  def initialize(country)
    @recipes = get_recipes(country)
  end

  def get_recipes(country)
    recipes = RecipesService.new.fetch_recipes(country)
    recipes[:hits].map do |recipe|
      Recipe.new(recipe[:recipe])
    end
  end
end
