class BikesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :verify_key
  respond_to :json

  def create
    api_url = params[:api_url]
    bike_index_api_response = bike_index_response(api_url)
    bike = Bike.create(bike_index_api_url: api_url,
      bike_index_api_response: bike_index_api_response,
      latitude: bike_index_api_response['stolen_record']['latitude'], 
      longitude: bike_index_api_response['stolen_record']['longitude'])

    new_tweet = TwitterTweeterIntegration.new(bike).create_tweet

    BikeIndexEmailGenerator.new.send_email_hash(new_tweet)

    render :nothing => true
  end

  def bike_index_response(bike_index_api_url)
    bike_response = Net::HTTP.get_response(URI.parse(bike_index_api_url)).body
    bike_response = JSON.parse(bike_response)
    bike_response['bikes']
  end

  private

  def verify_key
    unless params[:key].present? && params[:key] == ENV['INCOMING_REQUEST_KEY']
      render json: "Not authorized", status: :unauthorized and return
    end
  end

end
