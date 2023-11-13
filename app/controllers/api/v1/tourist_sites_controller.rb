class Api::V1::TouristSitesController < ApplicationController
  def index
    places = TouristSitesFacade.new(params[:country]).places
    render json: TouristSiteSerializer.new(places)
  end
end