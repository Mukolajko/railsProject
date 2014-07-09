class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :all_users, :select_options, :current_user, :find_user, :sort_direction, :sort_column

  private

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def find_user(username)
  	@user_to_add = User.find_by_username(username) ? User.find_by_username(username).id : nil
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "taskname"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def select_options
    @select_options = [
                        ["New", "new"], 
                        ["In progress", "in_progress"], 
                        ["Fixed", "fixed"], 
                        ["Qa", "qa"], 
                        ["Done", "done"],
                        ["Cannot reproduce", "cannot_reproduce"],
                        ["Close", "close"],
                      ]
  end

  def all_users
    @all_users = []
    User.all.each do |user|
      if current_user.id != user.id 
        @all_users << ["#{user.username}", user.id]
      end
    end
  end
end
