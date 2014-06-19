class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  	  redirect_to root_url, :notice => "sighned up"
  	else
  	  flash.now[:alert] = "errors"
  	  render "new"
  	end
  end
end
