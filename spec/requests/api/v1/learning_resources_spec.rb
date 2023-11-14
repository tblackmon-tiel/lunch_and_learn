require 'rails_helper'

RSpec.describe "Learning Resources Endpoint", type: :request do
  describe "happy paths" do
    it "returns a hash when provided with a country", :vcr do
      get "/api/v1/learning_resources?country=laos"
      expect(response).to be_successful

      resource = JSON.parse(response.body, symbolize_names: true)
      expect(resource).to be_a Hash
      expect(resource).to have_key(:data)
      expect(resource[:data]).to be_a Hash

      data = resource[:data]
      expect(data).to have_key(:id)
      expect(data[:id]).to be nil
      expect(data).to have_key(:type)
      expect(data[:type]).to be_a String
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      attributes = data[:attributes]
      expect(attributes).to have_key(:country)
      expect(attributes[:country]).to be_a String
      expect(attributes).to have_key(:video)
      expect(attributes[:video]).to be_a Hash
      expect(attributes[:video][:title]).to be_a String
      expect(attributes[:video][:youtube_video_id]).to be_a String
      expect(attributes).to have_key(:images)
      expect(attributes[:images]).to be_an Array

      attributes[:images].each do |image|
        expect(image).to be_a Hash
        expect(image).to have_key(:alt_tag)
        expect(image[:alt_tag]).to be_a String
        expect(image).to have_key(:url)
        expect(image[:url]).to be_a String
      end
    end
  end

  describe "sad paths" do
    it "returns an empty video hash if no videos can be found", :vcr do
      get "/api/v1/learning_resources?country=sdmfgjkajlsd"
      expect(response).to be_successful

      resource = JSON.parse(response.body, symbolize_names: true)
      attributes = resource[:data][:attributes]
      
      expect(attributes).to have_key(:video)
      expect(attributes[:video]).to be_a Hash
      expect(attributes[:video]).to be_empty
    end

    it "returns an empty images array if no images can be found", :vcr do
      get "/api/v1/learning_resources?country=sdmfgjkajlsd"
      expect(response).to be_successful

      resource = JSON.parse(response.body, symbolize_names: true)
      attributes = resource[:data][:attributes]

      expect(attributes).to have_key(:images)
      expect(attributes[:images]).to be_an Array
      expect(attributes[:images]).to be_empty
    end
  end
end