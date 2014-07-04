 RailsProject::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"	
  get "sign_up" => "users#new", :as => "sign_up"
  get "/tasks/:id/:status" => "tasks#change_status", :as => "task_change"
  get "/modal/:taskname" => "tasks#modal"
  get "/edit_tasks" => "tasks#show_user_tasks", :as => "edit_tasks"
  post "/add_user" => "users#add_user_to_task", :as => "add_user"
  get "/:user_id/:task_id/remove/(.:username)" => "users#remove_user_from_task", :as => "remove_user"
  root :to => "users#index"  
  resources :users do
    resources :tasks
  end
  resources :sessions
end 
