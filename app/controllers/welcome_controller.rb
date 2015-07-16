class WelcomeController < ApplicationController
  skip_before_filter :ensure_authorized_user

  def index
    redirect_to :account_index and return if current_user.present?
    @noheader = true
  end

end