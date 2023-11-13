class RecipesService
  def conn
    Faraday.new(
      url: "https://api.edamam.com",
      params: {
        type: "public",
        app_id: "8d788e59",
        app_key: "8831e364124e938aae8e26c9f90c57d5"
      }
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def fetch_recipes(params)
    get_url("/api/recipes/v2?q=#{params}")
  end
end