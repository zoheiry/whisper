Rails.application.routes.draw do
  # get 'authy/two-step'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  root 'home#index'

  get '/a/:username' => 'conversations#add_friend'

  get '/your_keys' => 'home#keys'

  get '/a/:user_id' => 'conversations#add_friend'

  get '/c/:channel_name' => 'conversations#conversation'

  post '/k/:public_key' => 'conversations#key'

  get '/two-step' => 'authy#two_step'

  post '/confirm_code' => 'authy#confirm'

  post '/create_group/:members' => "home#create_group"

  post '/acc_pend' => "home#accept", as: :accept_pending

  # devise_for :users

  # devise_for :users

  # devise_for :users

  get '/your_keys' => 'home#keys'
  get '/location/index' => 'location_sharing#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
