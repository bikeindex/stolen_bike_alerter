class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :ensure_authorized_user

  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"].uid, request.env["omniauth.auth"])
    @user.update_twitter_info(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      puts request.env["omniauth.auth"]
      flash[:error] = "We're sorry, we failed to sign you in. Please contact admin@bikeindex.org"
      redirect_to root_url
    end
  end
end