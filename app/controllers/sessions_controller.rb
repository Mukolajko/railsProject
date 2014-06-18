class SessionsController < ApplicationController
  def create
  	user = User.authenticate(params[:login], params[:password])
  	if user
  	  session[:user_id] = user.id
  	  redirect_to root_url, :notice => "Logged In!"
  	else
  	  flash.now.alert = "Incorrect data"
  	  render "new"
  	end	
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out"
  end
end
