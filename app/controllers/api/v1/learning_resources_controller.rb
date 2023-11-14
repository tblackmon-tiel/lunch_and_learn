class Api::V1::LearningResourcesController < ApplicationController
  def index
    resource = LearningResourcesFacade.new(params[:country]).resource
    render json: LearningResourceSerializer.new(resource)
  end
end