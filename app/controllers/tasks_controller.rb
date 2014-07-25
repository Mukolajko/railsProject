 class TasksController < ApplicationController
  include TasksHelper
  helper_method :sort_column, :sort_direction
  before_filter :get_task, :only => [:edit, :update, :destroy, :modal]
  before_filter :get_shared_users, :only => [:edit, :modal]
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
    @task.taskfiles.build
    render '_taskform'
  end
  
  def create
    if params[:task][:sharedtasks_attributes] != nil
      params[:task][:sharedtasks_attributes] = check_for_duplicates(params[:task][:sharedtasks_attributes])
    end
    params[:task][:status] = "new"    
    @task = current_user.tasks.create(task_params)
    errors = {}
    if @task.valid?
      params[:taskfiles_multiple].each_with_index do |v, index| 
        taskfile = @task.taskfiles.new(:file => v)
        errors["Taskfile_#{index}"] = taskfile.errors.full_messages.join(";") unless taskfile.save
      end
    else
      errors["task"] = @task.errors.full_messages.join(";")
    end 
    flash = errors.empty? ? {:notice => "Add to DB"} : {:alert => errors.map{|k,v| "#{k} => #{v}"}} 
    redirect_to user_path(current_user.id), flash
  end

  def edit
    @taskfiles = @task.taskfiles
  end

  def update
    if params[:task][:sharedtasks_attributes] != nil
      params[:task][:sharedtasks_attributes] = check_for_duplicates(params[:task][:sharedtasks_attributes], @task.id)
    end
    flash = @task.update_attributes(task_params) ? {:notice => "Task updated"} : {:notice =>  @task.errors.full_messages.first}
    redirect_to :back, flash
  end

  def destroy
    notice = Task.find_by_id(params[:id]).destroy ? "Task removed" : "Something went wrong. Try again!"
    redirect_to user_path(current_user.id), :notice =>  notice
  end

  def show_user_tasks
    @tasks = current_user.tasks
    @users_links = Hash.new
    for task in @tasks
      @users_links[task.taskname] = []
      task.usersintask.each {|user| @users_links[task.taskname] << users_info(user)}
    end
  end

  def change_status
    if params[:status]
      @task = Task.find_by_id(params[:id])
      if params[:status] == "close"
        @task[:task_type] = "lock"
      end
      render :json => @task.send(params[:status]) and return
    end
  end

  def modal
    @taskfiles = @task.taskfiles
    render "_taskform", :layout => false
  end

  def side_bar_task
    @task = Task.find_by_id(params[:task_id])
    @taskusers = @task.users
    render "show_task_side_bar", :layout => false
  end

  def remove_file_from_task
    @query = Taskfile.find_by_id(params[:file_id]).destroy
    render :json => @query and return
  end
  private   

  def get_task
    @task = Task.find_by_id(params[:id])
  end

  def get_shared_users
    @taskusers = @task.users
  end

  def check_for_duplicates(parameters, task_id = false)
    @without_duplicates = parameters.invert.invert
    if task_id
      @without_duplicates.delete_if {|k, v| Sharedtask.exists?(:user_id => v["user_id"], :task_id => task_id)}
    end
    return @without_duplicates
  end

  def task_params
    params.require(:task).permit(:description, :taskname, :user_id, :status, :task_number, :task_type, taskfiles_attributes: [:file], sharedtasks_attributes: [:user_id, :task_id])
  end
end
