require 'rails_helper'

RSpec.describe "User Favorites Endpoint", type: :request do
  describe "happy paths" do
    describe "post endpoint" do
      it "creates a favorite and returns a success message when a user posts" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        favorite = {
          "api_key": user[:api_key],
          "country": "thailand",
          "recipe_link": "https://www.tastingtable.com/.....",
          "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
        }
        post "/api/v1/favorites", params: favorite, as: :json
  
        expect(response).to be_successful
        
        success = JSON.parse(response.body, symbolize_names: true)
        expect(success).to be_a Hash
        expect(success).to have_key(:success)
        expect(success[:success]).to eq("Favorite added successfully")
  
        expect(Favorite.last.user_id).to eq(user.id)
        expect(Favorite.last.country).to eq("thailand")
        expect(Favorite.last.recipe_link).to eq("https://www.tastingtable.com/.....")
        expect(Favorite.last.recipe_title).to eq("Crab Fried Rice (Khaao Pad Bpu)")
      end
    end

    describe "get endpoint" do
      it "returns favorites of a user given an api key" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        Favorite.create!(user_id: user.id, country: "thailand", recipe_link: "www.test.com/aaa", recipe_title: "Wow food!")
        Favorite.create!(user_id: user.id, country: "murica", recipe_link: "www.test.com/aaa-america", recipe_title: "Wow food but america!")
  
        get "/api/v1/favorites?api_key=#{user.api_key}"
        expect(response).to be_successful
  
        favorites = JSON.parse(response.body, symbolize_names: true)
        expect(favorites).to be_a Hash
        expect(favorites).to have_key(:data)
        expect(favorites[:data]).to be_an Array
  
        favorites[:data].each do |favorite|
          expect(favorite).to be_a Hash
          expect(favorite).to have_key(:id)
          expect(favorite[:id]).to be_a String
          expect(favorite).to have_key(:type)
          expect(favorite[:type]).to eq("favorite")
          expect(favorite).to have_key(:attributes)
          expect(favorite[:attributes]).to be_a Hash
          
          attributes = favorite[:attributes]
          expect(attributes).to have_key(:recipe_title)
          expect(attributes[:recipe_title]).to be_a String
          expect(attributes).to have_key(:recipe_link)
          expect(attributes[:recipe_link]).to be_a String
          expect(attributes).to have_key(:country)
          expect(attributes[:country]).to be_a String
          expect(attributes).to have_key(:created_at)
          expect(attributes[:created_at]).to be_a String
  
          expect(attributes).to_not have_key(:user_id)
          expect(attributes).to_not have_key(:api_key)
        end
      end
    end
  end

  describe "sad paths" do
    describe "post endpoint" do

      it "responds with an error when a bad api key is sent while creating a favorite" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        favorite = {
          "api_key": "123",
          "country": "thailand",
          "recipe_link": "https://www.tastingtable.com/.....",
          "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
        }
        post "/api/v1/favorites", params: favorite, as: :json
  
        expect(response).to_not be_successful
        expect(response.status).to eq(401)
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Invalid API key")
      end
  
      it "responds with appropriate errors when country is missing" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        favorite = {
          "api_key": "123456789abcd",
          "recipe_link": "https://www.tastingtable.com/.....",
          "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
        }
        post "/api/v1/favorites", params: favorite, as: :json
  
        expect(response).to_not be_successful
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Country can't be blank")
      end
  
      it "responds with appropriate errors when recipe_link is missing" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        favorite = {
          "api_key": "123456789abcd",
          "country": "thailand",
          "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
        }
        post "/api/v1/favorites", params: favorite, as: :json
  
        expect(response).to_not be_successful
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Recipe link can't be blank")
      end
  
      it "responds with appropriate errors when recipe_title is missing" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        favorite = {
          "api_key": "123456789abcd",
          "country": "thailand",
          "recipe_link": "https://www.tastingtable.com/....."
        }
        post "/api/v1/favorites", params: favorite, as: :json
  
        expect(response).to_not be_successful
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Recipe title can't be blank")
      end
  
      it "responds with an error if no params are sent in the request body" do
        post "/api/v1/favorites?test=true"
  
        expect(response).to_not be_successful
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Please send data in the request body")
      end
    end

    describe "get endpoint" do
      it "responds with appropriate errors when api key is passed as a query param but is invalid" do
        get "/api/v1/favorites?api_key=1"

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to be_a Hash
        expect(error).to have_key(:errors)
        expect(error[:errors]).to eq("Invalid API key")
      end
  
      it "sends back an empty data array if a user has no favorites" do
        user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
        
        get "/api/v1/favorites?api_key=#{user.api_key}"

        expect(response).to be_successful
        
        favorites = JSON.parse(response.body, symbolize_names: true)
        expect(favorites).to be_a Hash
        expect(favorites).to have_key(:data)
        expect(favorites[:data]).to be_an Array
        expect(favorites[:data]).to be_empty
      end
    end
  end
end