require 'rails_helper'

RSpec.describe LearningResource do
  it "exists" do
    country = "south sudan"
    video = {
      title: "video title",
      youtube_video_id: "youtube id"
    }
    images = [
      {
        alt_description: "white aircraft",
        url: "some url"
      },
      {
        alt_description: "four men holding rifles",
        url: "some url 2"
      }
    ]

    resource = LearningResource.new(country, video, images)
    expect(resource).to be_a LearningResource
    expect(resource.id).to be nil
    expect(resource.country).to eq(country)
    expect(resource.video).to eq(video)
    expect(resource.images).to eq(images)
  end
end