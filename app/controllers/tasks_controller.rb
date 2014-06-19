class TasksController < ApplicationController
  layout "tasks"	
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

  def show
  	@userTasks = Task.user_tasks(current_user.username)
  end
end
