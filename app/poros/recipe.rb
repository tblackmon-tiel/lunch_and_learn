class Recipe
  attr_reader :id,
              :title,
              :url,
              :country,
              :image

  def initialize(details, country)
    @id = nil
    @title = details[:label]
    @url = details[:uri]
    @country = country
    @image = details[:image]
  end
end