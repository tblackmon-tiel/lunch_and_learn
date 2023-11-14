class Api::V1::LearningResourcesController < ApplicationController
  def index
    test = LearningResource.new
    render json: LearningResourceSerializer.new(test)
  end
end