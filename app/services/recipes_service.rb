class RecipesService
  def conn
    Faraday.new(
      url: "https://api.edamam.com",
      params: {
        type: "public",
        app_id: Rails.application.credentials.edamame[:app_id],
        app_key: Rails.application.credentials.edamame[:app_key]
      }
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def fetch_recipes(params)
    encoded_uri = URI.encode_www_form_component(params) # handle escaped characters from random countries
    get_url("/api/recipes/v2?q=#{encoded_uri}")
  end
end