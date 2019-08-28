class TwitterAccountsController < ApplicationController
  before_filter :set_twitter_account, except: [:index]

  def index
    redirect_to twitter_account_path(id: current_user.screen_name) and return unless current_user.is_admin
    @accounts = TwitterAccount.order(created_at: :desc)
  end

  def show
    @account = current_user.twitter_account unless @account.present?
  end

  def update
    if @account.update(account_params)
      redirect_to twitter_account_path(id: @account.screen_name), notice: "Account was successfully updated."
    else
      render twitter_account(id: @account.screen_name), error: @account.errors.messages
    end
  end

  private

  def set_twitter_account
    return false unless current_user.present?
    if current_user.is_admin
      screen_name = params[:twitter_account] && params[:twitter_account][:screen_name] || params[:id]
      @account = TwitterAccount.where(screen_name: screen_name.downcase).first
    else
      @account = current_user.twitter_account
    end
  end

  def account_params
    params.require(:twitter_account).permit(:is_active, :append_block, :address,
                                            :latitude, :longitude)
  end
end
