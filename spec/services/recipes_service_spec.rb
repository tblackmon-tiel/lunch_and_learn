require 'rails_helper'

RSpec.describe RecipesService do
  describe "#fetch_recipes" do
    it "returns a collection of recipes given a query", :vcr do
      query = "thailand"
      response = RecipesService.new.fetch_recipes(query)

      expect(response).to be_a Hash
      expect(response).to have_key(:hits)
      expect(response[:hits]).to be_an Array

      response[:hits].each do |recipe|
        expect(recipe).to be_a Hash
        expect(recipe).to have_key(:recipe)
        expect(recipe[:recipe]).to be_a Hash

        details = recipe[:recipe]

        expect(details).to have_key(:uri)
        expect(details[:uri]).to be_a String
        expect(details).to have_key(:label)
        expect(details[:label]).to be_a String
        expect(details).to have_key(:image)
        expect(details[:image]).to be_a String
      end
    end
  end
end