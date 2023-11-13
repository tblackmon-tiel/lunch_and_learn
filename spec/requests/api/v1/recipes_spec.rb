require 'rails_helper'

RSpec.describe "Recipes Endpoint", type: :request do
  describe "when I make a get request to the /api/v1/recipes endpoints" do
    it "with a query param of a country, it should return recipes related to that country", :vcr do
      get "/api/v1/recipes?country=thailand"

      expect(response).to be_successful
      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(recipes).to be_a Hash
      expect(recipes[:data]).to be_an Array

      recipes[:data].each do |recipe|
        expect(recipe).to have_key(:id)
        expect(recipe[:id]).to be nil
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

    it "returns an empty data array if country is a blank string" do
      get "/api/v1/recipes?country="

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)
      expect(recipes).to have_key(:data)
      expect(recipes[:data]).to be_an Array
      expect(recipes[:data]).to be_empty
    end

    it "returns recipes from a random country if no country param is passed" do
      VCR.use_cassette('custom/random_country_recipe', match_requests_on: [:method, VCR.request_matchers.uri_without_params('q')]) do
        get "/api/v1/recipes"

        expect(response).to be_successful
        recipes = JSON.parse(response.body, symbolize_names: true)

        expect(recipes).to be_a Hash
        expect(recipes[:data]).to be_an Array

        recipes[:data].each do |recipe|
          expect(recipe).to have_key(:id)
          expect(recipe[:id]).to be nil
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
    end

    it "returns an empty data array if no results are found", :vcr do
      get "/api/v1/recipes?country=sfjklsdfjklv"

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)
      expect(recipes).to have_key(:data)
      expect(recipes[:data]).to be_an Array
      expect(recipes[:data]).to be_empty
    end

    xit "does not include extraneous info in attributes" do
      #todo
    end
  end
end