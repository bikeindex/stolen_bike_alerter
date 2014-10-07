desc "Get account info"
task :get_account_info => :environment do
  TwitterAccount.each do |twitter_account|
    twitter_account.get_account_info
    twitter_account.save
  end
end

desc "add tweet info to all the tweets" 
# task :add_tweet_info => :environment do
  # maybe do this?
# end