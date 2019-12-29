Rails.application.routes.draw do
  devise_for :users,
  controllers: { sessions: 'user_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    post 'create' => 'user_sessions#create'
    post 'saml_signin' => 'user_sessions#saml_signin'
    post 'sign_up' => 'user_sessions#sign_up'
    # Routes for Google authentication
    get 'auth/:provider/callback', to: 'user_sessions#googleAuth'
    get 'auth/failure', to: redirect('/')
  end
  
  namespace :api do
    namespace :v1 do

      resources :users do
        collection do
          get :profile
        end
      end

      resources :projects do
        member do
          patch :update
          delete :destroy
          get :tasks
        end
        collection do
          post :create
          get :index
        end
      end

      resources :tasks do
        member do
          patch :update
          delete :destroy
          get :comments
        end
        collection do
          post :create
          get :index
        end
      end

      resources :comments do
        member do
          patch :update
          delete :destroy
        end
        collection do
          post :create
          get :index
        end
      end

    end
  end

  resources :user_sessions do
    collection do
      post :sign_up
      post :saml_signin
      post :log_in
    end
  end

end
