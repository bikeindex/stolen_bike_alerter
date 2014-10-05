class Bike < ActiveRecord::Base
  # Attributes  bike_index_api_url, bike_index_api_response, bike_index_bike_id
  #             city, state, neighborhood, latitude, longitude

  has_one :tweet
  has_many :retweets
  has_one :base_emails
  validates_presence_of :bike_index_api_url
  validates_presence_of :bike_index_api_response
  serialize :bike_index_api_response
  
  before_validation :serialize_api_response
  
  reverse_geocoded_by :latitude, :longitude do |bike,results|
    if geo = results.first
      bike.city    = geo.city
      bike.state   = geo.state_code
      bike.neighborhood = geo.neighborhood
    end
  end
  after_validation :reverse_geocode

  def serialize_api_response
    self.bike_index_api_response = ActiveSupport::HashWithIndifferentAccess.new(bike_index_api_response)
    self.bike_index_bike_id = bike_index_api_response[:id]
  end

end
