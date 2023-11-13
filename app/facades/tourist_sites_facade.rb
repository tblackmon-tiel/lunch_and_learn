class TouristSitesFacade
  attr_reader :places

  def initialize(country)
    @places = get_places(country)
  end

  def get_places(country)
    coords = get_coords(country)
    places = PlacesService.new.fetch_nearby_places(coords[1], coords[0])
    places[:features].map {|place| Place.new(place[:properties])}
  end

  def get_coords(country)
    country_details = CountriesService.new.country_details(country).first
    # protect against results with no capital (antarctica)
    country_details[:capitalInfo][:latlng] ? country_details[:capitalInfo][:latlng] : country_details[:latlng]
  end
end