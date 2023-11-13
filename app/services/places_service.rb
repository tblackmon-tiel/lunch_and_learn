class PlacesService
  def conn
    Faraday.new(
      url: "https://api.geoapify.com/v2/places",
      params: {apiKey: Rails.application.credentials.places[:apiKey]}
      )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def fetch_nearby_places(long, lat)
    get_url("/v2/places?categories=tourism&filter=circle:#{long},#{lat},1000")
  end
end