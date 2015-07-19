class BikesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  skip_before_filter  :ensure_authorized_user
  before_filter :verify_key
  respond_to :json

  def create
    api_url = params[:api_url]
    bike = Bike.create_from_api_url(api_url)
    new_tweet = TwitterTweeterIntegration.new(bike).create_tweet
    BikeIndexEmailGenerator.new.send_email_hash(new_tweet)
    render :nothing => true
  end

  private
  def verify_key
    unless params[:key].present? && params[:key] == ENV['INCOMING_REQUEST_KEY']
      render json: "Not authorized", status: :unauthorized and return
    end
  end

end
