class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy, :modal]
  before_filter :get_shared_tasks, :only => [:edit, :modal]
  before_filter :all_users, :only => [:edit, :modal, :new]
  before_filter :select_options, :only => [:show_user_tasks]

  def index
      @all_tasks = Task.includes(:users)
                    .order("#{sort_column} #{sort_direction}")
                    .paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @task = Task.new
    shared = @task.sharedtasks.build
    render '_taskform'
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

  def update
    if @task.update_attributes(params[:task])
      redirect_to :back, :notice => "Task updated"
    else
      redirect_to :back, :notice => "Something went wrong. Try again!"  
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
    @shared_users_count = Hash.new
    @shared_users_id = Hash.new
    for task in @tasks
      @shared_users_count[task.taskname], @shared_users_id[task.taskname] = 0, []
      for user in task.usersintask
        @shared_users_id[task.taskname] << [user.id, user.username]
        @shared_users_count[task.taskname] += 1
      end
    end
  end

  def change_status
    if params[:status]
      @task = Task.find_by_id(params[:id])
        render :json => @task.send(params[:status]) and return
    end
  end

  def modal
    render "_taskform"
  end

  private   

  def get_task
    @task = Task.find_by_id(params[:id])
  end

  def get_shared_tasks
    @taskusers = @task.sharedtasks
    @users = []
    for el in @taskusers
      @users << User.find_by_id(el["user_id"]).username
    end
  end
end
