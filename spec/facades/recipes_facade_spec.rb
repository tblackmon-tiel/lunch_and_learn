require 'rails_helper'

RSpec.describe RecipesFacade do
  it "exists" do
    VCR.use_cassette('custom/random_country_recipe_facade', match_requests_on: [:method, VCR.request_matchers.uri_without_params('q')]) do
      facade = RecipesFacade.new

      expect(facade).to be_a RecipesFacade
      expect(facade.recipes).to be_an Array
      facade.recipes.each do |recipe|
        expect(recipe).to be_a Recipe
      end
    end
  end

  it "can be passed a country", :vcr do
    facade = RecipesFacade.new("laos")

    expect(facade).to be_a RecipesFacade
    expect(facade.recipes).to be_an Array
    facade.recipes.each do |recipe|
      expect(recipe).to be_a Recipe
    end
  end
end