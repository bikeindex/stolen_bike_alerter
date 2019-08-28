class TwitterTweeterIntegration
  require "twitter"
  require "geocoder"
  require "tempfile"
  require "open-uri"

  def initialize(bike)
    @bike = bike
  end

  attr_accessor :max_char, :close_twitters, :retweets

  def set_close_twitters
    @close_twitters = @bike.twitter_accounts_in_proximity
  end

  # To manually send a tweet (e.g. if authentication failed)
  # TwitterTweeterIntegration.new(Bike.find_by_bike_index_bike_id(XXX)).create_tweet
  def create_tweet
    set_close_twitters
    update_str = build_bike_status
    update_opts = {
      lat: @bike.bike_index_api_response[:stolen_record][:latitude],
      long: @bike.bike_index_api_response[:stolen_record][:longitude],
      display_coordinates: "true",
    }
    client = twitter_client_start(@close_twitters.first)

    posted_tweet = nil # If this isn't instantiated, it isn't accessible outside media block.
    begin
      if (@bike.bike_index_api_response[:photo])
        Tempfile.open("foto.jpg") do |foto|
          foto.binmode
          foto.write open(@bike.bike_index_api_response[:photo]).read
          foto.rewind
          posted_tweet = client.update_with_media(update_str, foto, update_opts)
        end
      else
        posted_tweet = client.update(update_str, update_opts)
      end
    rescue Twitter::Error::Unauthorized => e
      raise Twitter::Error::Unauthorized, "#{@close_twitters.first.screen_name} #{e}"
    end

    @tweet = Tweet.create(twitter_tweet_id: posted_tweet.id,
                          twitter_account_id: @close_twitters.first[:id], # Maybe use shift here?
                          bike_id: @bike.id,
                          tweet_string: update_str)

    retweet(posted_tweet)
    @tweet
  end

  def retweet(posted_tweet)
    @retweets = [posted_tweet]
    @close_twitters.each do |twitter_name|
      next if twitter_name.id == @tweet.twitter_account_id
      client = twitter_client_start(twitter_name)
      begin
        # retweet returns an array even with scalar parameters
        posted_retweet = client.retweet(@tweet[:twitter_tweet_id]).first
        @retweets.push(posted_retweet)
        retweet = Retweet.create(twitter_tweet_id: posted_retweet.id,
                                 twitter_account_id: twitter_name.id,
                                 bike_id: @tweet.bike.id,
                                 tweet_id: @tweet.id)
        raise StandardError, retweet.errors.full_messages.to_sentence unless retweet.id.present?
      rescue Twitter::Error::Unauthorized => e
        raise Twitter::Error::Unauthorized, "#{@close_twitters.first.screen_name} #{e}"
      end
    end
    @retweets
  end

  def stolen_slug
    @bike.bike_index_api_response[:serial].present? ? "STOLEN -" : "FOUND -"
  end

  def set_max_char
    # TODO store these constants in the database and update them once a day with a REST client.configuration call
    #max_char = @tweet_length - @https_length - at_screen_name.length - 3 # spaces between slugs

    tweet_length = 140
    https_length = 23
    media_length = 23

    @max_char = tweet_length - https_length - stolen_slug.size - 3 # spaces between slugs
    @max_char -= @bike.bike_index_api_response[:photo] ? media_length : 0
  end

  def tweet_string(stolen_slug, bike_slug, url)
    "#{stolen_slug} #{bike_slug} #{url}"
  end

  def tweet_string_with_options(stolen_slug, bike_slug, url)
    ts = tweet_string(stolen_slug, bike_slug, url)
    if @close_twitters && @close_twitters.first.present? && @close_twitters.first.append_block.present?
      block = @close_twitters.first.append_block
      ts << " #{block}" if (ts.length + block.length) < @max_char
    end
    ts
  end

  # Perform the conditional text processing to create a reply string
  # that fits twitter's limits
  #
  # @param bike [Hash] bike hash as delivered by BikeIndex that we're going to tweet about
  def build_bike_status
    set_max_char
    location = ""
    if !(@close_twitters.first && @close_twitters.first.default) && @bike.neighborhood.present?
      location = "in #{@bike.neighborhood}"
    elsif @bike.city.present? && @bike.state.present?
      location = "in #{@bike.city}, #{@bike.state}"
    end
    # location = @close_twitters.first.default ? "in #{@bike.city}, #{@bike.state}" : "in #{@bike.neighborhood}"

    color = @bike.bike_index_api_response[:frame_colors][0]
    if color.start_with?("Silver")
      color.replace "Gray"
    elsif color.start_with?("Stickers")
      color.replace ""
    end

    manufacturer = @bike.bike_index_api_response[:manufacturer_name]
    model = @bike.bike_index_api_response[:frame_model]

    full_length = color.size + model.size + manufacturer.size + location.size + 3
    if full_length <= @max_char
      bike_slug = "#{color} #{manufacturer} #{model} #{location}"
    elsif full_length - color.size - 1 <= @max_char
      bike_slug = "#{manufacturer} #{model} #{location}"
    elsif full_length - manufacturer.size - 1 <= @max_char
      bike_slug = "#{color} #{model} #{location}"
    elsif full_length - model.size - 1 <= @max_char
      bike_slug = "#{color} #{manufacturer} #{location}"
    elsif model.size + 2 <= @max_char
      bike_slug = "a #{model}"
    elsif manufacturer.size + 2 <= @max_char
      bike_slug = "a #{manufacturer}"
    elsif color.size + 5 <= @max_char
      bike_slug = "#{color} bike"
    else
      bike_slug = ""
    end

    tweet_string_with_options(stolen_slug, bike_slug, @bike.bike_index_api_response["url"])
  end

  def twitter_client_start(twitter_account)
    Twitter::REST::Client.new do |config|
      config.consumer_key = twitter_account[:consumer_key]
      config.consumer_secret = twitter_account[:consumer_secret]
      config.access_token = twitter_account[:user_token]
      config.access_token_secret = twitter_account[:user_secret]
    end
  end
end
