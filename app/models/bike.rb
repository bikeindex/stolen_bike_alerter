class Bike < ActiveRecord::Base
  has_one :tweet
  has_many :retweets
  has_one :base_emails
  validates_presence_of :bike_index_api_url
  validates_presence_of :bike_index_api_response
  serialize :bike_index_api_response
  attr_accessor :no_geocode

  after_validation :reverse_geocode
  reverse_geocoded_by :latitude, :longitude do |bike,results|
    if !bike.no_geocode && geo = results.first
      bike.country    = geo.country
      bike.city    = geo.city
      bike.state   = geo.state_code
      bike.neighborhood = geo.neighborhood
    end
  end

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
    JSON.parse(HTTParty.get(uri).body)['bikes']
  end

  def self.binx_id_from_url(api_url)
    api_url.strip[/\d*\z/].to_i
  end

  def self.api_v1_url_from_binx_id(bike_id)
    "https://bikeindex.org/api/v1/bikes/#{bike_id}"
  end

  def is_api_v1 
    bike_index_api_url.match(/api\/v1\//i).present?
  end

  def twitter_accounts_in_proximity
    default = TwitterAccount.default_account_for_country(country)
    TwitterAccount.active.near(self, 50).where.not(id: default.id) << default
  end

end