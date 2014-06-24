 RailsProject::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"	
  get "sign_up" => "users#new", :as => "sign_up"
  post "add_user" => "tasks#add_user_to_task"
  root :to => "users#new"
  
  resources :users do 
    resources :tasks  
  end
  resources :sessions
end 
