class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy]
  before_filter :select_options, :only => [:show_user_tasks]

  def index
    @all_tasks = Task.includes(:users)
                    .order("#{sort_column} #{sort_direction}")
                    .paginate(:per_page => 10, :page => params[:page])
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
  def show_user_tasks
    @tasks = current_user.tasks
  end

  def change_status
    if params[:status]
      @task = Task.find_by_id(params[:id])
        render :json => @task.send(params[:status]) and return
    end
  end


  private   

  def get_task
    @task = Task.find_by_id(params[:id])
  end
end
