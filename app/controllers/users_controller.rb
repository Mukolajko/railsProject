class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user]) 
  	if @user.save
      session[:user_id] = @user.id
  	  redirect_to user_tasks_path(@user.id), :notice => "sighned up"
  	else
  	  render "new"
  	end
  end
end
