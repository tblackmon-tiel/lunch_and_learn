class RecipesSerializer
  include JSONAPI::Serializer
  attributes :title, :url, :country, :image
end
