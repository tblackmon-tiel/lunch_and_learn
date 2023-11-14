require 'rails_helper'

RSpec.describe YoutubeService do
  describe "#serach_video_by_country" do
    it "returns a single video from the Mr History channel related to the passed country", :vcr do
      response = YoutubeService.new.search_video_by_country("south sudan")
      
      expect(response).to be_a Hash
      expect(response).to have_key(:kind)
      expect(response[:kind]).to be_a String
      expect(response).to have_key(:regionCode)
      expect(response[:regionCode]).to be_a String
      expect(response).to have_key(:pageInfo)
      expect(response[:pageInfo]).to be_a Hash
      expect(response).to have_key(:items)
      expect(response[:items]).to be_an Array

      response[:items].each do |item|
        expect(item).to be_a Hash
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a Hash
        expect(item[:id]).to have_key(:videoId)
        expect(item[:id][:videoId]).to be_a String
        expect(item).to have_key(:snippet)
        expect(item[:snippet]).to be_a Hash

        snippet = item[:snippet]
        expect(snippet).to have_key(:title)
        expect(snippet[:title]).to be_a String
      end
    end
  end
end