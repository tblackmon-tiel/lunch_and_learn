require 'rails_helper'

RSpec.describe FavoritesCreateFacade do
  it "exists with a user and new_favorite instance variable" do
    user = User.create!(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", api_key: "123456789abcd")
    favorite = {
      "api_key": user[:api_key],
      "country": "thailand",
      "recipe_link": "https://www.tastingtable.com/.....",
      "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
    }.to_json

    facade = FavoritesCreateFacade.new(favorite)
    expect(facade).to be_a FavoritesCreateFacade
    expect(facade.user).to eq(user)
    expect(facade.new_favorite).to be_a Favorite
  end

  it "handles users not being able to be found" do
    favorite = {
      "api_key": "123456789abcd",
      "country": "thailand",
      "recipe_link": "https://www.tastingtable.com/.....",
      "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
    }.to_json

    facade = FavoritesCreateFacade.new(favorite)
    expect(facade).to be_a FavoritesCreateFacade
    expect(facade.user).to be nil
    expect(facade.new_favorite).to be nil
  end
end