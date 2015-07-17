class Bike < ActiveRecord::Base
  # Attributes  bike_index_api_url, bike_index_api_response, bike_index_bike_id
  #             city, state, neighborhood, latitude, longitude

  has_one :tweet
  has_many :retweets
  has_one :base_emails
  validates_presence_of :bike_index_api_url
  validates_presence_of :bike_index_api_response
  serialize :bike_index_api_response
  
  reverse_geocoded_by :latitude, :longitude do |bike,results|
    if geo = results.first
      bike.city    = geo.city
      bike.state   = geo.state_code
      bike.neighborhood = geo.neighborhood
    end
  end
  after_validation :reverse_geocode

  def self.create_from_api_url(api_url)
    bike_id = binx_id_from_url(api_url)
    api_response = get_api_response(bike_id).with_indifferent_access
    self.create(bike_index_api_url: api_v1_url_from_binx_id(bike_id).to_s,
      bike_index_bike_id: bike_id,
      bike_index_api_response: api_response,
      latitude: api_response[:stolen_record][:latitude], 
      longitude: api_response[:stolen_record][:longitude],
    )
  end

  def self.get_api_response(bike_id)
    uri = api_v1_url_from_binx_id(bike_id)
    JSON.parse(Net::HTTP.get_response(uri).body)['bikes']
  end

  def self.binx_id_from_url(api_url)
    api_url.strip[/\d*\z/].to_i
  end

  def self.api_v1_url_from_binx_id(bike_id)
    URI.parse("https://bikeindex.org/api/v1/bikes/#{bike_id}")
  end


  def is_api_v1 
    bike_index_api_url.match(/api\/v1\//i).present?
  end

end
