class TasksController < ApplicationController
  layout "tasks"
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
                 .order("#{sort_column} #{sort_direction}")
                 .paginate(:per_page => 5, :page => params[:page])
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.create(params[:task])
    if @task.save
      redirect_to user_tasks_path(current_user.id), :notice => "Add task to DB"
    else
      redirect_to user_tasks_path(current_user.id), :notice => "Something went wrong. Try again!"
    end
  end

  def edit
    @taskusers = @task.sharedtasks
    @users = []
    for el in @taskusers
      @users << User.find_by_id(el["user_id"]).username
    end
  end

  def update
    if @task.update_attributes(params[:task])
      redirect_to user_tasks_path(current_user.id), :notice => "Task updated"
    else
      redirect_to user_tasks_path(current_user.id), :notice => "Something went wrong. Try again!"  
    end
  end

  def destroy
    if Task.find_by_id(params[:id]).destroy
      redirect_to user_tasks_path(current_user.id), :notice => "Task removed"
    else
      redirect_to user_tasks_path(current_user.id), :notice => "Something went wrong. Try again!"
    end
  end

  def add_user_to_task
    @user_to_add = find_user(params[:username])
    @check_for_duplicates = Sharedtask.where("user_id = ? AND task_id = ?", @user_to_add, params[:task_id]).first
    if @check_for_duplicates != nil || @user_to_add == nil
      redirect_to edit_user_task_path(current_user.id, params[:task_id]), :notice => "User already in task or user doesn't exist"
    else
      @user = User.find_by_id(@user_to_add)
      @user.sharedtasks.create user_id: @user_to_add, task_id: params[:task_id]
      redirect_to edit_user_task_path(current_user.id,params[:task_id]), :notice => "User add in task!"  
    end
  end

  def remove_user_from_task
    @user_to_remove = find_user(params[:username])   
    if Sharedtask.where("user_id = ? AND task_id = ?", @user_to_remove, params[:id]).first.destroy
      flash[:notice] = "User removed"     
    else
      flash[:notice] = "Something bad happened. Try aggin!"
    end
    redirect_to edit_user_task_path(current_user.id, params[:id])
  end

  private 
  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "taskname"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def get_task
    @task = Task.find_by_id(params[:id])
  end
end
