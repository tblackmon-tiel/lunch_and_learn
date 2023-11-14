require 'rails_helper'

RSpec.describe UnsplashService do
  describe "#get_images_by_country" do
    it "returns a hash of image details when provided a country", :vcr do
      response = UnsplashService.new.get_images_by_country("south sudan")
      expect(response).to be_a Hash
      expect(response).to have_key(:results)
      expect(response[:results]).to be_an Array

      response[:results].each do |result|
        expect(result).to be_a Hash
        expect(result).to have_key(:id)
        expect(result[:id]).to be_a String
        expect(result).to have_key(:description)
        expect(result[:description]).to be_a String if result[:description]
        expect(result).to have_key(:alt_description)
        expect(result[:alt_description]).to be_a String if result[:alt_description]
        expect(result).to have_key(:urls)
        expect(result[:urls]).to be_a Hash
        
        urls = result[:urls]
        expect(urls).to have_key(:raw)
        expect(urls[:raw]).to be_a String
      end
    end
  end
end