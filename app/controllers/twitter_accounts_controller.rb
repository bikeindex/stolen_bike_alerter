class TwitterAccountsController < ApplicationController
  
  def show
    @account = current_user.twitter_account
  end

  def update
    @account = current_user.twitter_account
    if @account.update(account_params)
      redirect_to twitter_account_path(@account.screen_name), notice: 'Account was successfully updated.'
    else
      render twitter_account(@account.screen_name), error: @account.errors.messages
    end
  end

  private

  def account_params
    params.require(:account).permit(:is_active, :append_block, :address, :latitude, :longitude)
  end

end