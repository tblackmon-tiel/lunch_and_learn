require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it {should validate_presence_of :user_id}
  it {should validate_presence_of :country}
  it {should validate_presence_of :recipe_link}
  it {should validate_presence_of :recipe_title}
end