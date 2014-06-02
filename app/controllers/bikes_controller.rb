class BikesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    bike = Bike.new do |b|
      b.bike_index_api_url = bike_params[:api_url]
      b.bike_index_api_response = JSON.parse(Net::HTTP.get_response(URI.parse(b.bike_index_api_url)).body)
      b.serialize_api_response
      b.save
    end
    
    TwitterTweeterIntegration.new(bike).create_tweet

    render :nothing => true
  end

  private
  
  def bike_params
    params.require(:api_url)
    params.permit(:api_url)
  end
end
