class TouristSitesFacade
  attr_reader :places

  def initialize(country)
    @places = get_places(country)
  end

  def get_places(country)
    coords = get_coords(country)
    places = PlacesService.new.fetch_nearby_places(coords[1], coords[0])
    places.map {|place| Place.new(place)}
  end

  def get_coords(country)
    country_details = CountryService.new.country_details(country)
    country_details[:capitalInfo][:latlng]
  end
end