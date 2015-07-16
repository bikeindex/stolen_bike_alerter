class WelcomeController < ApplicationController
  skip_before_filter :ensure_authorized_user

  def index
    redirect_to twitter_account_path(current_user.screen_name) and return if current_user.present?
    @noheader = true
  end

end