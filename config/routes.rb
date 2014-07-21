RailsProject::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "show/user/:id" => "users#show_user", :as => "show_user"
  get "tasks/:id/:status" => "tasks#change_status", :as => "task_change"
  get "modal/:id" => "tasks#modal"
  get "show_task/side_bar/:task_id" => "tasks#side_bar_task"
  get "edit_tasks" => "tasks#show_user_tasks", :as => "edit_tasks"
  get "remove/:task_id/:username" => "users#remove_user_from_task"
  get "removefile/:file_id" => "tasks#remove_file_from_task"
  # You can have the root of your site routed with "root"
  root 'users#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :users do
    resources :tasks
  end
  resources :sessions
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
