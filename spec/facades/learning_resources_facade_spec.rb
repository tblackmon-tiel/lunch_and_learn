require 'rails_helper'

RSpec.describe LearningResourcesFacade do
  it "exists and builds a resource for a given country", :vcr do
    facade = LearningResourcesFacade.new("south sudan")
    expect(facade).to be_a LearningResourcesFacade
    expect(facade.resource).to be_a LearningResource
  end

  it "handles bad queries", :vcr do
    facade = LearningResourcesFacade.new("hskdlfjhkasdk")
    expect(facade).to be_a LearningResourcesFacade
    expect(facade.resource).to be_a LearningResource

    expect(facade.resource.images).to be_empty
    expect(facade.resource.video).to be_empty
  end
end