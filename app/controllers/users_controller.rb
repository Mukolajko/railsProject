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
  	@user = User.new(params[:user]) 
  	if @user.save
      session[:user_id] = @user.id
  	  redirect_to user_path(@user.id), :notice => "sighned up"
  	else
  	  render "new"
  	end
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
end
