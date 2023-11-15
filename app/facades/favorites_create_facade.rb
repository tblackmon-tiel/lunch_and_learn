class FavoritesCreateFacade
  attr_reader :user, :new_favorite
  
  def initialize(request)
    @request = JSON.parse(request, symbolize_names: true)
    @user = find_user
    @new_favorite = create_new_favorite
  end

  def find_user
    User.find_by(api_key: @request[:api_key])
  end

  def create_new_favorite
    Favorite.new(
      user_id: @user.id,
      country: @request[:country],
      recipe_link: @request[:recipe_link],
      recipe_title: @request[:recipe_title]
    ) if @user
  end
end