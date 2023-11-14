require 'rails_helper'

RSpec.describe LearningResourcesFacade do
  it "exists and builds a resource for a given country", :vcr do
    facade = LearningResourcesFacade.new("south sudan")
    expect(facade).to be_a LearningResourcesFacade
    expect(facade.resource).to be_a LearningResource
  end
end