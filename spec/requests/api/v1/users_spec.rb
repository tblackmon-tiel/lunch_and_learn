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
      expect(user).to have_key(:data)
      expect(user[:data]).to be_a Hash

      data = user[:data]
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("user")
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a String
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
    it "returns an error if email doesn't exist" do
      user = {
        "name": "Odell",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Email can't be blank")
      expect(User.last).to be nil
    end

    it "returns an error if password doesn't exist" do
      user = {
        "name": "Odell",
        "email": "goodboy@ruffruff.com",
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Password can't be blank and Password can't be blank")
      expect(User.last).to be nil
    end

    it "returns an error if name doesn't exist" do
      user = {
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Name can't be blank")
      expect(User.last).to be nil
    end

    it "returns an error if password and confirmation don't match" do
      user = {
        "name": "Odell",
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf",
        "password_confirmation": "aaaa"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Password confirmation doesn't match Password")
      expect(User.last).to be nil
    end

    it "returns an error if email is not unique" do
      user = {
        "name": "Odell",
        "email": "goodboy@ruffruff.com",
        "password": "treats4lyf",
        "password_confirmation": "treats4lyf"
      }

      post "/api/v1/users", params: user, as: :json
      expect(response).to be_successful
      expect(User.last.email).to eq("goodboy@ruffruff.com")
      user_id = User.last.id

      post "/api/v1/users", params: user, as: :json
      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error).to have_key(:errors)
      expect(error[:errors]).to eq("Email has already been taken")
      expect(User.last.email).to eq("goodboy@ruffruff.com")
      expect(User.last.id).to eq(user_id)
    end
  end
end