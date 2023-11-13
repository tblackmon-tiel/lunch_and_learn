require 'rails_helper'

RSpec.describe CountriesService do
  describe "#all_countries" do
    it "returns a list of all countries, filtered down to name", :vcr do
      countries = CountriesService.new.all_countries

      expect(countries).to be_an Array

      countries.each do |country|
        expect(country).to have_key(:name)
        expect(country[:name]).to be_a Hash

        name = country[:name]

        expect(name).to have_key(:common)
        expect(name[:common]).to be_a String
        expect(name).to have_key(:official)
        expect(name[:official]).to be_a String
      end
    end
  end

  describe "#country_details" do
    it "returns details on a given country", :vcr do
      countries = CountriesService.new.country_details("latvia")

      expect(countries).to be_an Array
      countries.each do |country|
        expect(country).to be_a Hash
        expect(country).to have_key(:name)
        expect(country[:name]).to be_a Hash
        expect(country[:name]).to have_key(:common)
        expect(country[:name][:common]).to be_a String

        expect(country).to have_key(:capital)
        expect(country[:capital]).to be_an Array
        expect(country[:capital].first).to be_a String

        expect(country).to have_key(:capitalInfo)
        expect(country[:capitalInfo]).to be_a Hash
        expect(country[:capitalInfo]).to have_key(:latlng)
        expect(country[:capitalInfo][:latlng]).to be_an Array
        expect(country[:capitalInfo][:latlng].first).to be_a Float
      end
    end
  end
end