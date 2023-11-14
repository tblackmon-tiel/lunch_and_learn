class YoutubeService
  def conn
    Faraday.new(
      url: "https://www.googleapis.com",
      params: {key: Rails.application.credentials.youtube[:key]}
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def search_video_by_country(country)
    get_url("/youtube/v3/search?part=snippet&channelId=UCluQ5yInbeAkkeCndNnUhpw&maxResults=1&q=#{country}")
  end
end