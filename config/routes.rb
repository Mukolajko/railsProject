 RailsProject::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"	
  get "sign_up" => "users#new", :as => "sign_up"
  get "tasks" => "tasks#index", :as => "tasks"
  get "tasks_new" => "tasks#new", :as => "tasks_new"
  get "tasks_edit" => "tasks#edit", :as => "tasks_edit"
  get "tasks_edit_task" => "tasks#edit_task", :as => "tasks_edit_task"
  put "tasks_update" => "tasks#update"
  get "tasks_delete" => "tasks#delete", :as => "tasks_delete"
  get "tasks_delete_conf" => "tasks#delete_conf"
  get "tasks_show" => "tasks#show", :as => "tasks_show"
  root :to => "users#new"
  resources :users, only: [:new, :create]
  resources :sessions
  resources :tasks  
end 
