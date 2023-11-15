require 'rails_helper'

RSpec.describe "User login endpoint", type: :request do
  describe "happy paths" do
    it "returns a user details hash when a user successfully authenticates" do
      User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
      user_auth = {
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf"
      }

      post "/api/v1/sessions", params: user_auth, as: :json
      expect(response).to be_successful

      user = JSON.parse(response.body, symbolize_names: true)
      expect(user).to be_a Hash
      expect(user).to have_key(:data)
      expect(user[:data]).to be_a Hash

      data = user[:data]
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a String
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("user")
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      attributes = data[:attributes]
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a String
      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to be_a String
      expect(attributes).to have_key(:api_key)
      expect(attributes[:api_key]).to be_a String
    end
  end

  describe "sad paths" do
    it "returns an error if the user cannot authenticate" do
      User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
      user_auth = {
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyfeee"
      }

      post "/api/v1/sessions", params: user_auth, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Could not authenticate: invalid email or password")
    end

    it "returns an error if the body does not contain both email and password" do
      User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
      user_auth = {
        "password": "treats4lyfeee"
      }

      post "/api/v1/sessions", params: user_auth, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Request is missing email and/or password")

      user_auth = {
        "email": "goodboy@ruffruff.com"
      }

      post "/api/v1/sessions", params: user_auth, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Request is missing email and/or password")
    end

    it "handles auth not being sent in the body" do
      post "/api/v1/sessions?test=true"

      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Please send authentication in the request body.")
    end
  end
end