require 'rails_helper'

RSpec.describe "Tourist Sites Endpoint", type: :request do
  describe "When I get the /api/v1/tourist_sites endpoint" do
    it "and I pass in a country parameter, I receive a list of tourist sites within a 1000m radius of the capital", :vcr do
      get "/api/v1/tourist_sites?country=Latvia"

      expect(response).to be_successful
      places = JSON.parse(response.body, symbolize_names: true)

      expect(places).to be_a Hash
      expect(places).to have_key(:data)
      expect(places[:data]).to be_an Array

      places[:data].each do |place|
        expect(place).to be_a Hash
        expect(place).to have_key(:id)
        expect(place[:id]).to be nil
        expect(place).to have_key(:type)
        expect(place[:type]).to eq("tourist_site")
        expect(place).to have_key(:attributes)
        expect(place[:attributes]).to be_a Hash

        attributes = place[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a String
        expect(attributes).to have_key(:address)
        expect(attributes[:address]).to be_a String
        expect(attributes).to have_key(:place_id)
        expect(attributes[:place_id]).to be_a String

        # double check no unnecessary data is presented from prior API calls
        expect(attributes).to_not have_key(:country)
        expect(attributes).to_not have_key(:state)
        expect(attributes).to_not have_key(:lon)
        expect(attributes).to_not have_key(:lat)
      end
    end

    it "returns results or an empty array even if the country has no capital", :vcr do
      get "/api/v1/tourist_sites?country=Antarctica"
  
      expect(response).to be_successful
      places = JSON.parse(response.body, symbolize_names: true)
      
      expect(places).to be_a Hash
      expect(places).to have_key(:data)
      expect(places[:data]).to be_an Array
      expect(places[:data]).to be_empty
    end

    it "returns an empty data array if no locations of interest are found", :vcr do
      get "/api/v1/tourist_sites?country=Uruguay"
  
      expect(response).to be_successful
      places = JSON.parse(response.body, symbolize_names: true)
      
      expect(places).to be_a Hash
      expect(places).to have_key(:data)
      expect(places[:data]).to be_an Array
      expect(places[:data]).to be_empty
    end
  end
end