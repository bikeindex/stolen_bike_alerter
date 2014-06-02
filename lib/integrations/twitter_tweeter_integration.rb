class TwitterTweeterIntegration
  require 'twitter'
  require 'geocoder'
  require 'tempfile'

  def initialize(bike)
    @bike = bike.bike_index_api_response[:bikes]
    @close_twitters = TwitterAccount.near(@bike[:stolen_record], 50) || TwitterAccount.where(default: true)
  end

  def create_tweet
    #close_twitters = TwitterAccount.near(bike.bike_index_api_response[:bikes][:stolen_record])
    update_str = build_bike_status(@bike)
    update_opts = { lat: @bike[:stolen_record][:latitude], long: @bike[:stolen_record][:longitude], display_coordinates: "true" }
    client = twitter_client_start(@close_twitters.shift)

    tweet = nil
    if (@bike[:photo])
      Tempfile.open(['foto', '.jpg'], nil, 'wb+') do |foto|
        foto.write open(@bike[:photo]).read
        foto.rewind
        tweet = client.update_with_media(update_str, foto, update_opts)
      end
    else
      tweet = client.update(update_str, update_opts)
    end

    retweet(tweet) if tweet && @close_twitters
  end

  private

  def retweet(tweet)
    @close_twitters.each do |twitter_name|
      client = twitter_client_start(twitter_name)
      client.retweet(tweet)
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
    max_char -= @bike[:photo] ? media_length : 0

    neighborhood = "in " + Geocoder.search([@bike[:stolen_record][:latitude], @bike[:stolen_record][:longitude]]).first.neighborhood

    color = @bike[:frame_colors][0]
    if color.start_with?("Silver")
      color.replace "Gray"
    elsif color.start_with?("Stickers")
      color.replace ''
    end

    manufacturer = @bike[:manufacturer_name]
    model = @bike[:frame_model]

    full_length = color.size + model.size + manufacturer.size + neighborhood.size + 3
    if full_length <= max_char
      bike_slug = "#{color} #{manufacturer} #{model} #{neighborhood}"
    elsif full_length - color.size - 1 <= max_char
      bike_slug = "#{manufacturer} #{model} #{neighborhood}"
    elsif full_length - manufacturer.size - 1 <= max_char
      bike_slug = "#{color} #{model} #{neighborhood}"
    elsif full_length - model.size - 1 <= max_char
      bike_slug = "#{color} #{manufacturer} #{neighborhood}"
    elsif model.size + 2 <= max_char
      bike_slug = "a #{model}"
    elsif manufacturer.size + 2 <= max_char
      bike_slug = "a #{manufacturer}"
    elsif color.size + 5 <= max_char
      bike_slug = "#{color} bike"
    else
      bike_slug = ""
    end

    return "#{stolen_slug} #{bike_slug} #{@bike["url"]}"
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
