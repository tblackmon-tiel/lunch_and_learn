class CountriesService
  def conn
    Faraday.new(url: "https://restcountries.com")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def all_countries
    get_url("/v3.1/all?fields=name")
  end

  def country_details(country)
    get_url("/v3.1/name/#{country}") #gsub space for %20 if needed for bad uri error
  end
end