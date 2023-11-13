require 'rails_helper'

RSpec.describe "Recipes Endpoint", type: :feature do
  describe "when I make a get request to the /api/v1/recipes endpoints" do
    it "with a query param of a country, it should return recipes related to that country", :vcr do
      get "/api/v1/recipes?country=thailand"

      expect(response.status).to be_successful

      response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_a Hash
      expect(response[:data]).to be_an Array

      response[:data].each do |recipe|
        expect(recipe).to have_key(:id)
        expect(recipe[:id]).to be_a String
        expect(recipe).to have_key(:type)
        expect(recipe[:type]).to be_a String
        expect(recipe).to have_key(:attributes)
        expect(recipe[:attributes]).to be_a Hash

        attributes = recipe[:attributes]

        expect(attributes).to have_key(:title)
        expect(attributes[:title]).to be_a String
        expect(attributes).to have_key(:url)
        expect(attributes[:url]).to be_a String
        expect(attributes).to have_key(:country)
        expect(attributes[:country]).to be_a String
        expect(attributes).to have_key(:image)
        expect(attributes[:image]).to be_a String
      end
    end

    xit "does not include extraneous info in attributes" do
      #todo
    end
  end
end