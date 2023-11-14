class LearningResourcesFacade
  attr_reader :resource
  
  def initialize(country)
    @resource = build_resource(country)
  end

  def build_resource(country)
    video = get_video(country)
    images = get_images(country)
    LearningResource.new(country, video, images)
  end

  def get_video(country)
    response = YoutubeService.new.search_video_by_country(country)
    video = response[:items].first
    if video
      {
        title: video[:snippet][:title],
        youtube_video_id: video[:id][:videoId]
      }
    else
      {}
    end
  end

  def get_images(country)
    response = UnsplashService.new.get_images_by_country(country)
    response[:results].map do |result|
      {
        alt_tag: result[:alt_description],
        url: result[:urls][:raw]
      }
    end
  end
end