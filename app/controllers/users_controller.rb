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

  def add_user_to_task
    @user_to_add = find_user(params[:username])
    @check_for_duplicates = Sharedtask.where("user_id = ? AND task_id = ?", @user_to_add, params[:task_id]).first
    if @check_for_duplicates != nil || @user_to_add == nil
      redirect_to :back, :notice => "User already in task or user doesn't exist"
    else
      @user = User.find_by_id(@user_to_add)
      @user.sharedtasks.create user_id: @user_to_add, task_id: params[:task_id]
      redirect_to :back, :notice => "Add to task!"
    end
  end

  def remove_user_from_task
    @user_to_remove = find_user(params[:username])   
    if Sharedtask.where("user_id = ? AND task_id = ?", @user_to_remove, params[:task_id]).first.destroy
      flash[:notice] = "User removed"     
    else
      flash[:notice] = "Something bad happened. Try aggin!"
    end
    redirect_to edit_user_task_path(current_user.id, params[:task_id])
  end

end
