class BikesController < ApplicationController
#  Dotenv.load
  skip_before_filter  :verify_authenticity_token
  before_filter :verify_key
  respond_to :json

  def create
    api_url = params[:api_url]
    bike_index_api_response = bike_index_response(api_url)
    bike = Bike.create(bike_index_api_url: api_url, bike_index_api_response: bike_index_api_response, latitude: bike_index_api_response['stolen_record']['latitude'],  longitude: bike_index_api_response['stolen_record']['longitude'])

    new_tweet = TwitterTweeterIntegration.new(bike).create_tweet
    BikeIndexEmailGenerator.new.send_email(new_tweet)

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



# class BikesController < ApplicationController
#   require 'dotenv'
#   Dotenv.load

#   skip_before_action :verify_authenticity_token

#   def create
#     bike = Bike.new do |b|
#       b.bike_index_api_url = bike_params[:api_url]
#       b.bike_index_api_response = JSON.parse(Net::HTTP.get_response(URI.parse(b.bike_index_api_url)).body)
#       b.serialize_api_response
#       b.save
#     end

#     new_tweet = TwitterTweeterIntegration.new(bike).create_tweet
#     BikeIndexEmailGenerator.new.send_email(new_tweet)


#     render :nothing => true
#   end

#   private

#   def bike_params
#     fail unless params.require(:key) == ENV['INCOMING_REQUEST_KEY']
#     params.require(:api_url)
#     params.permit(:api_url)
#   end
# end
