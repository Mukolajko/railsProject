class TasksController < ApplicationController
  layout "tasks"
  helper_method :sort_column, :sort_direction
  before_filter :getTasks

  def index

  end

  def new
  	@task = Task.new
  end

  def create
	  @task = Task.new(params[:task].merge(:username => current_user.username))
  	if @task.save
  	  redirect_to tasks_path, :notice => "Add task to DB"
  	else
  	  redirect_to tasks_path, :notice => "Something went wrong. Try again!"
  	end
  end

  def edit_task
    if Task.checkURL(params[:id], current_user.username)
      @editTask = Task.find_by_id(params[:id])
    else
      nil
    end
  end

  def update
    @changed = Task.find_by_id(params[:id])
    @changed.taskname = params[:task][:taskname]
    @changed.description = params[:task][:description]
    if @changed.save
      redirect_to tasks_path, :notice => "Task Updated!"
    else
      redirect_to :back, :notice => "Error"
    end   
  end

  def delete_conf
    @removed = Task.find_by_id(params[:id])
    if @removed.destroy
      redirect_to tasks_path, :notice => "Deleted"
    else
      redirect_to :back, :notice => "Error"
    end
  end

  def getTasks
    @userTasks = Task.user_tasks(current_user.username)
      .order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
  end

  private 

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "taskname"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
