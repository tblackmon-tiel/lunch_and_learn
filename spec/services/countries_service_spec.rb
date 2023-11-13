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
end