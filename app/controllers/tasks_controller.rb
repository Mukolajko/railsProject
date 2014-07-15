class TasksController < ApplicationController
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
    render '_taskform'
  end
  
  def create
    if params[:task][:sharedtasks_attributes] != nil
      params[:task][:sharedtasks_attributes] = check_for_duplicates(params[:task][:sharedtasks_attributes])
    end
    params[:task][:status] = "new"
    @task = current_user.tasks.create(task_params)
    flash = @task.save ? {:notice => "Add task to DB"} : {:alert => "Something went wrong. Try again!"}
    redirect_to user_path(current_user.id), flash
  end

  def update
    if params[:task][:sharedtasks_attributes] != nil
      params[:task][:sharedtasks_attributes] = check_for_duplicates(params[:task][:sharedtasks_attributes], @task.id)
    end
    notice = @task.update_attributes(task_params) ? "Task updated" : "Something went wrong. Try again!"
    redirect_to :back, :notice => notice
  end

  def destroy
    notice = Task.find_by_id(params[:id]).destroy ? "Task removed" : "Something went wrong. Try again!"
    redirect_to user_path(current_user.id), :notice =>  notice
  end

  def show_user_tasks
    @tasks = current_user.tasks
    @shared_users_count, @shared_users_id = Hash.new, Hash.new
    for task in @tasks
      @shared_users_count[task.taskname], @shared_users_id[task.taskname] = 0, []
      for user in task.usersintask
        user_link = view_context.link_to("#{user.username} ", show_user_path(user.id))
        @shared_users_id[task.taskname] << user_link
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
    render "_taskform", :layout => false
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
    params.require(:task).permit(:description, :taskname, :user_id, :status, sharedtasks_attributes: [:user_id, :task_id])
  end
end
