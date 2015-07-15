## stolen_bike_alerter

[![Code Climate](https://codeclimate.com/github/adherr/stolen_bike_alerter/badges/gpa.svg)](https://codeclimate.com/github/adherr/stolen_bike_alerter)

Takes api_url POSTed to it and creates a media tweet in the
stolenbikecity twitter account where the bike was stolen. Sends an
email back to BikeIndex to tell the bike owner what happened and to retweet.

## Set up

To get this to work locally you'll have to [create an app on Twitter](https://apps.twitter.com/app/new) and add environmental variables `OMNIAUTH_CONSUMER_KEY` and `OMNIAUTH_CONSUMER_SECRET`.

## How to add a new twitter account to the app

**OLD SCHOOL** - now just go to the webpage and authenticate with twitter, then input your info and you're good.

1. Create the new account on twitter -- it has to have a unique email. Write the email and the password in the Google Doc.

2. While signed in to your new account, create a twitter app at apps.twitter.com. It should probably be called stolenbikesXXX if you want to keep with our naming theme.

3. In the Keys and Access Tokens tab you need the Consumer Key, Consumer Secret, and click on Generate Access Token and get the key and secret that that gives you as well.

4. Record the above values in the google doc.

5. Add the above values to the seeds file.

6. Log in to the heroku with 'heroku run rails c production' and add the above values to the twitter_accounts table (see seed file for the proper column names.)
