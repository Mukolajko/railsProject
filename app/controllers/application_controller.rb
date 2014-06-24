class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :find_user

  private

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def find_user(username)
  	@user_to_add = User.find_by_username(username) ? User.find_by_username(username).id : nil
  end
end
