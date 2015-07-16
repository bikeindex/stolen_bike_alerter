class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?
  before_action :ensure_authorized_user

  def ssl_configured?
    Rails.env.production?
  end

  def ensure_authorized_user
    unless current_user.present?
      session[:sandr] ||= request.url unless controller_name.match('session')
      redirect_to user_omniauth_authorize_path(:twitter) and return
    end
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:sandr].present? ? session.delete(:sandr) : account_index_url
  end

end
