class AccountController < ApplicationController
  
  def index
    @account = current_user
  end

  def update
  end

end