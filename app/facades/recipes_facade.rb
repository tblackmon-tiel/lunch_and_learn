class RecipesFacade
  attr_reader :recipes

  def initialize(country = nil)
    @recipes = get_recipes(country)
  end

  def get_recipes(country)
    if country
      recipes = RecipesService.new.fetch_recipes(country)
    else
      random_country = CountriesService.new.all_countries.sample[:name]
      country = random_country[:common] # common is the "spoken" version of the country
      recipes = RecipesService.new.fetch_recipes(country)
    end
    
    recipes[:hits].map do |recipe|
      Recipe.new(recipe[:recipe], country)
    end
  end
end
