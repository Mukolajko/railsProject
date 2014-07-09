 RailsProject::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"	
  get "sign_up" => "users#new", :as => "sign_up"
  get "show/user/:id" => "users#show_user", :as => "show_user"
  get "/tasks/:id/:status" => "tasks#change_status", :as => "task_change"
  get "/modal/:id" => "tasks#modal"
  get "/edit_tasks" => "tasks#show_user_tasks", :as => "edit_tasks"
  get "/remove/:task_id/:username" => "users#remove_user_from_task"
  root :to => "users#index"  
  resources :users do
    resources :tasks
  end
  resources :sessions
end 
