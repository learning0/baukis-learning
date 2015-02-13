# == Route Map
#
#                  Prefix Verb   URI Pattern                             Controller#Action
#              staff_root GET    /                                       staff/top#index {:host=>"baukis.example.com"}
#             staff_login GET    /login(.:format)                        staff/sessions#new {:host=>"baukis.example.com"}
#           staff_session POST   /session(.:format)                      staff/sessions#create {:host=>"baukis.example.com"}
#                         DELETE /session(.:format)                      staff/sessions#destroy {:host=>"baukis.example.com"}
#           staff_account POST   /account(.:format)                      staff/accounts#create {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#       new_staff_account GET    /account/new(.:format)                  staff/accounts#new {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#      edit_staff_account GET    /account/edit(.:format)                 staff/accounts#edit {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         GET    /account(.:format)                      staff/accounts#show {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         PATCH  /account(.:format)                      staff/accounts#update {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         PUT    /account(.:format)                      staff/accounts#update {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         DELETE /account(.:format)                      staff/accounts#destroy {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#              admin_root GET    /admin(.:format)                        admin/top#index {:host=>"baukis.example.com"}
#             admin_login GET    /admin/login(.:format)                  admin/sessions#new {:host=>"baukis.example.com"}
#           admin_session POST   /admin/session(.:format)                admin/sessions#create {:host=>"baukis.example.com"}
#                         DELETE /admin/session(.:format)                admin/sessions#destroy {:host=>"baukis.example.com"}
#     admin_staff_members GET    /admin/staff_members(.:format)          admin/staff_members#index {:host=>"baukis.example.com"}
#                         POST   /admin/staff_members(.:format)          admin/staff_members#create {:host=>"baukis.example.com"}
#  new_admin_staff_member GET    /admin/staff_members/new(.:format)      admin/staff_members#new {:host=>"baukis.example.com"}
# edit_admin_staff_member GET    /admin/staff_members/:id/edit(.:format) admin/staff_members#edit {:host=>"baukis.example.com"}
#      admin_staff_member GET    /admin/staff_members/:id(.:format)      admin/staff_members#show {:host=>"baukis.example.com"}
#                         PATCH  /admin/staff_members/:id(.:format)      admin/staff_members#update {:host=>"baukis.example.com"}
#                         PUT    /admin/staff_members/:id(.:format)      admin/staff_members#update {:host=>"baukis.example.com"}
#                         DELETE /admin/staff_members/:id(.:format)      admin/staff_members#destroy {:host=>"baukis.example.com"}
#           customer_root GET    /mypage(.:format)                       customer/top#index {:host=>"baukis.example.com"}
#          customer_login GET    /mypage/login(.:format)                 customer/sessions#new {:host=>"baukis.example.com"}
#        customer_session POST   /mypage/session(.:format)               customer/sessions#create {:host=>"baukis.example.com"}
#                         DELETE /mypage/session(.:format)               customer/sessions#destroy {:host=>"baukis.example.com"}
#        customer_account POST   /mypage/account(.:format)               customer/accounts#createdate {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#    new_customer_account GET    /mypage/account/new(.:format)           customer/accounts#new {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#   edit_customer_account GET    /mypage/account/edit(.:format)          customer/accounts#edit {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         GET    /mypage/account(.:format)               customer/accounts#show {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         PATCH  /mypage/account(.:format)               customer/accounts#update {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         PUT    /mypage/account(.:format)               customer/accounts#update {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                         DELETE /mypage/account(.:format)               customer/accounts#destroy {:host=>"baukis.example.com", :exept=>[:new, :create, :destroy]}
#                    root GET    /                                       errors#routing_error
#                         GET    /*anything(.:format)                    errors#routing_error
#

Rails.application.routes.draw do
  config = Rails.application.config.baukis
  
  constraints host: config[:staff][:host] do
    namespace :staff, path: config[:staff][:path] do
      root 'top#index'
      get 'login' => 'sessions#new', as: :login
      resource :session, only: [ :create, :destroy ]
      resource :account, except: [ :new, :create, :destroy ] do
        patch :confirm
      end
      resource :password, only: [ :show, :edit, :update ]
      resources :customers
      resources :programs do
        patch :entries, on: :member
      end
      resources :messages, only: [ :index, :show, :destroy ] do
        get :inbound, :outbound, :deleted, :count, on: :collection
        resource :reply, only: [ :new, :create ] do
          post :confirm
        end
      end
    end
  end
  
  constraints host: config[:admin][:host] do
    namespace :admin, path: config[:admin][:path] do
      root 'top#index'
      get 'login'=> 'sessions#new', as: :login
      resource :session, only: [ :create, :destroy ]
      resources :staff_members do
        resources :staff_events, only: [ :index ]
      end
      resources :staff_events, only: [ :index ]
      resources :allowed_sources, only: [ :index, :create ] do
        delete :delete, on: :collection
      end
    end
  end
  
  constraints host: config[:customer][:host] do
    namespace :customer, path: config[:customer][:path] do
      root 'top#index'
      get 'login'=> 'sessions#new', as: :login
      resource :session, only: [ :create, :destroy ]
      resource :account, except: [ :new, :create, :destroy ] do
        patch :confirm
      end
      resources :programs, only: [ :index, :show ] do
        resources :entries, only: [ :create ] do
          patch :cancel, on: :member
        end
      end
      resources :messages, only: [ :new, :create ] do
        post :confirm, on: :collection
      end
    end
  end
  
  root 'errors#not_found'
  get '*anything' => 'errors#not_found'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
