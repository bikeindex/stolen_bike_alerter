class TwitterTweeterIntegration
  require 'twitter'
  require 'geocoder'
  require 'tempfile'
  require 'open-uri'

  def initialize(bike)
    @bike = bike
    @close_twitters = TwitterAccount.near(@bike, 50).presence || [ TwitterAccount.where(default: true) ]
  end

  def create_tweet
    update_str = build_bike_status
    update_opts = { lat: @bike.bike_index_api_response[:stolen_record][:latitude], long: @bike.bike_index_api_response[:stolen_record][:longitude], display_coordinates: "true" }
    client = twitter_client_start(@close_twitters.first)

    new_tweet = nil
    if (@bike.bike_index_api_response[:photo])
      Tempfile.open(['foto', '.jpg'], nil, 'wb+') do |foto|
        foto.binmode
        foto.write open(@bike.bike_index_api_response[:photo]).read
        foto.rewind
        new_tweet = client.update_with_media(update_str, foto, update_opts)
      end
    else
      new_tweet = client.update(update_str, update_opts)
    end

    @tweet = Tweet.create(twitter_tweet_id: new_tweet.id, twitter_account_id: @close_twitters.first[:id], bike_id: Bike.where(bike_index_api_url: @bike.bike_index_api_response[:api_url]).first[:id])

    retweet if @close_twitters.size > 1
    return @tweet
  end

  private

  
  def retweet
    retweets = []
    @close_twitters.each do |twitter_name|
      next if twitter_name.id == @tweet.twitter_account_id
      client = twitter_client_start(twitter_name)
      # retweet returns an array even with scalar parameters
      rt = client.retweet(@tweet[:twitter_tweet_id]).first
      retweets.push(Retweet.create(twitter_tweet_id: rt.id, twitter_account_id: twitter_name.id, bike_id: @tweet.bike.id, tweet_id: @tweet.id))
    end
  end

  # Perform the conditional text processing to create a reply string
  # that fits twitter's limits
  #
  # @param bike [Hash] bike hash as delivered by BikeIndex that we're going to tweet about
  def build_bike_status
    # TODO store these constants in the database and update them once a day with a REST client.configuration call
    #max_char = @tweet_length - @https_length - at_screen_name.length - 3 # spaces between slugs
    
    tweet_length = 140
    https_length = 23
    media_length = 23
    stolen_slug = "STOLEN -"
    max_char = tweet_length - https_length - stolen_slug.size - 3 # spaces between slugs
    max_char -= @bike.bike_index_api_response[:photo] ? media_length : 0

    location = @close_twitters.first.default ? "in #{@bike.city}, #{@bike.state}" : "in #{@bike.neighborhood}"

    color = @bike.bike_index_api_response[:frame_colors][0]
    if color.start_with?("Silver")
      color.replace "Gray"
    elsif color.start_with?("Stickers")
      color.replace ''
    end

    manufacturer = @bike.bike_index_api_response[:manufacturer_name]
    model = @bike.bike_index_api_response[:frame_model]

    full_length = color.size + model.size + manufacturer.size + location.size + 3
    if full_length <= max_char
      bike_slug = "#{color} #{manufacturer} #{model} #{location}"
    elsif full_length - color.size - 1 <= max_char
      bike_slug = "#{manufacturer} #{model} #{location}"
    elsif full_length - manufacturer.size - 1 <= max_char
      bike_slug = "#{color} #{model} #{location}"
    elsif full_length - model.size - 1 <= max_char
      bike_slug = "#{color} #{manufacturer} #{location}"
    elsif model.size + 2 <= max_char
      bike_slug = "a #{model}"
    elsif manufacturer.size + 2 <= max_char
      bike_slug = "a #{manufacturer}"
    elsif color.size + 5 <= max_char
      bike_slug = "#{color} bike"
    else
      bike_slug = ""
    end

    return "#{stolen_slug} #{bike_slug} #{@bike.bike_index_api_response["url"]}"
  end

  def twitter_client_start(twitter_account)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = twitter_account[:consumer_key]
      config.consumer_secret     = twitter_account[:consumer_secret]
      config.access_token        = twitter_account[:user_token]
      config.access_token_secret = twitter_account[:user_secret]
    end
  end
end
