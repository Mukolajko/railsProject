class TasksController < ApplicationController
  layout "tasks"
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy]

  def index
    @tasks = Task.user_tasks(current_user.username)
                 .order("#{sort_column} #{sort_direction}")
                 .paginate(:per_page => 5, :page => params[:page])
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(params[:task].merge(:username => current_user.username))
    if @task.save
      redirect_to user_tasks_path(current_user.id), :notice => "Add task to DB"
    else
      redirect_to user_tasks_path(current_user.id), :notice => "Something went wrong. Try again!"
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
