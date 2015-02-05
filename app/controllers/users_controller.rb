class UsersController < ApplicationController
  def index
    if params[:search]
      @tasks = current_user.tasks.where("taskname LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      if @tasks.first
        return
      else
        @tasks = nil
      end
    else
      @no_query = true
    end
  end

  def new
  	@user = User.new
  end

  def show_user
    @user = User.find_by_id(params[:id])
  end

  def create
  	@user = User.new(user_params) 
  	if @user.save
      session[:user_id] = @user.id
  	  redirect_to user_path(@user.id), :notice => "sighned up"
  	else
  	  flash.now[:alert] = "errors"
  	  render "new"
  	end
  end

  def update
    flash = current_user.update_attributes(user_params) ? {:notice => "Updated"} : {:notice => current_user.errors.full_messages.to_sentence}
    redirect_to :back, flash
  end

  def show
    @tasks = current_user.tasks
                         .order("#{sort_column} #{sort_direction}")
                         .paginate(:per_page => 5, :page => params[:page])
  end

  def remove_user_from_task
    @user_to_remove = find_user(params[:username])   
    @query = Sharedtask.where("user_id = ? AND task_id = ?", @user_to_remove, params[:task_id]).first.destroy
    render :json => @query and return
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :avatar)
  end
end
