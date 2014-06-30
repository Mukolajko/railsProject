class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy]
  before_filter :select_options, :only => [:dragdrop]

  def index   
    @all_tasks = Task.includes(:users).paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.create(params[:task])
    @task.status = "new"
    if @task.save
      redirect_to user_path(current_user.id), :notice => "Add task to DB"
    else
      redirect_to user_path(current_user.id), :notice => "Something went wrong. Try again!"
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
      redirect_to user_path(current_user.id), :notice => "Task updated"
    else
      redirect_to user_path(current_user.id), :notice => "Something went wrong. Try again!"  
    end
  end

  def destroy
    if Task.find_by_id(params[:id]).destroy
      redirect_to user_path(current_user.id), :notice => "Task removed"
    else
      redirect_to user_path(current_user.id), :notice => "Something went wrong. Try again!"
    end
  end

  def dragdrop
    if params[:taskname]
      Task.find_by_taskname(params[:taskname]).update_attributes(status: params[:to])
    end
    @tasks = current_user.tasks
  end
  private   

  def get_task
    @task = Task.find_by_id(params[:id])
  end
end
