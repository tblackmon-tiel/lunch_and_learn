require 'rails_helper'

RSpec.describe TouristSitesFacade do
  it "initializes with a list of places", :vcr do
    facade = TouristSitesFacade.new("latvia")
    expect(facade).to be_a TouristSitesFacade

    expect(facade.places).to be_an Array

    if !facade.places.empty?
      facade.places.each do |place|
        expect(place).to be_a Place
        expect(place.id).to be nil
        expect(place.name).to be_a String
        expect(place.address).to be_a String
        expect(place.place_id).to be_a String
      end
    end
  end
end