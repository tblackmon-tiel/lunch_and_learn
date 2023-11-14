require 'rails_helper'

RSpec.describe Recipe do
  it "exists" do
    country = "south sudan"
    details = {
      label: "test label",
      uri: "test uri",
      image: "test image"
    }

    recipe = Recipe.new(details, country)
    expect(recipe).to be_a Recipe
    expect(recipe.id).to be nil
    expect(recipe.country).to eq(country)
    expect(recipe.title).to eq(details[:label])
    expect(recipe.url).to eq(details[:uri])
    expect(recipe.image).to eq(details[:image])
  end
end