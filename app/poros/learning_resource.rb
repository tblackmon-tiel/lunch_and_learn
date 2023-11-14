class LearningResource
  attr_reader :id,
              :country,
              :video,
              :images
              
  def initialize
    @id = nil
    @country = "test"
    @video = {
      title: "video title",
      youtube_video_id: "youtube video id"
    }
    @images = [
      {
        alt_tag: "sample description",
        url: "sample url.com"
      },
      {
        alt_tag: "sample description 2",
        url: "sample url2.com"
      }
    ]
  end
end