require 'rails_helper'

RSpec.describe "Users Endpoint", type: :request do
  describe "happy paths" do
    it "registers a user on post" do
      user = {
        "name": "Odell",
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json

      expect(User.last).to be_a User
      expect(User.last.name).to eq(user[:name])
      expect(User.last.email).to eq(user[:email])
      expect(User.last.password_digest).to be_a String
      expect(User.last.api_key).to be_a String
    end

    it "returns the user's details on success" do
      user = {
        "name": "Odell",
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to be_successful

      user = JSON.parse(response.body, symbolize_names: true)
      expect(user).to be_a Hash
      expect(user).to have_key(:type)
      expect(user[:type]).to eq("user")
      expect(user).to have_key(:id)
      expect(user[:id]).to be_an Integer
      expect(user).to have_key(:attributes)
      expect(user[:attributes]).to be_a Hash

      attributes = user[:attributes]
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a String
      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to be_a String
      expect(attributes).to have_key(:api_key)
      expect(attributes[:api_key]).to be_a String
    end
  end

  describe "sad paths" do
    it "returns an error if user registration fails" do
      user = {
        "name": "Odell",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful
      # require 'pry';binding.pry
    end
  end
end