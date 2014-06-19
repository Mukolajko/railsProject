RailsProject::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"	
  get "sign_up" => "users#new", :as => "sign_up"
  get "tasks" => "tasks#index", :as => "tasks"
  get "tasks_new" => "tasks#new", :as => "tasks_new"
  get "tasks_show" => "tasks#show", :as => "tasks_show"
  root :to => "users#new"
  resources :users
  resources :sessions
  resources :tasks, only: [:index, :new, :show, :create]	  
end 
