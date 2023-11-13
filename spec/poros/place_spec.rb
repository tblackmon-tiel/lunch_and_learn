require 'rails_helper'

RSpec.describe Place do
  it "exists" do
    details = {name: "test name", formatted: "formatted address", place_id: "12345"}
    place = Place.new(details)

    expect(place).to be_a Place
    expect(place.name).to eq(details[:name])
    expect(place.address).to eq(details[:formatted])
    expect(place.place_id).to eq(details[:place_id])
  end
end