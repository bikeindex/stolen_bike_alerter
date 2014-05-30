class Bike < ActiveRecord::Base
  # :bike_index_api_url, :bike_index_api_response

  has_many :tweets
  validates_presence_of :bike_index_api_url
  serialize :bike_index_api_response

  def serialize_api_response
    self.bike_index_api_response = ActiveSupport::HashWithIndifferentAccess.new(bike_index_api_response)
  end

end
