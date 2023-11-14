class UnsplashService
  def conn
    Faraday.new(
      url: "https://api.unsplash.com",
      params: {client_id: Rails.application.credentials.unsplash[:access_key]}
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_images_by_country(country)
    get_url("/search/photos?query=#{country}")
  end
end