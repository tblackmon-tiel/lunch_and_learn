class Place
  attr_reader :id,
              :name,
              :address,
              :place_id
              
  def initialize(details)
    @id = nil
    @name = details[:name]
    @address = details[:formatted]
    @place_id = details[:place_id]
  end
end