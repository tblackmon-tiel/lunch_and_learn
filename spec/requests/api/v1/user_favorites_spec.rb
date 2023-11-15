require 'rails_helper'

RSpec.describe "User Favorites Endpoint", type: :request do
  describe "happy paths" do
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

  describe "sad paths" do
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

    it "responds with an error if no params are sent in the request body" do
      post "/api/v1/favorites?test=true"

      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Please send data in the request body.")
    end
  end
end