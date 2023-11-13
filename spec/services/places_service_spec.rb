require 'rails_helper'

RSpec.describe PlacesService do
  before(:each) do
    @service = PlacesService.new
  end

  it "exists" do
    expect(@service).to be_a PlacesService
  end

  describe "#fetch_nearby_places" do
    it "returns a collection of places within 1000m of a given long and lat", :vcr do
      long = "174.7787"
      lat = "-41.2924"
      places = @service.fetch_nearby_places(long, lat)

      expect(places).to be_a Hash
      expect(places).to have_key(:features)
      expect(places[:features]).to be_an Array

      places[:features].each do |place|
        expect(place).to be_a Hash
        expect(place).to have_key(:properties)
        properties = place[:properties]

        expect(properties).to be_a Hash
        expect(properties).to have_key(:name)
        expect(properties[:name]).to be_a String
        expect(properties).to have_key(:formatted)
        expect(properties[:formatted]).to be_a String
        expect(properties).to have_key(:place_id)
        expect(properties[:place_id]).to be_a String
      end
    end
  end
end