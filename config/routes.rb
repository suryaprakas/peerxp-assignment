Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      resources :users do
        collection do
          get :list_trainer
        end
      end
    end
  end
  # get '/api' => redirect('/swagger/dist/index.html?url=/apidocs/api/v1/api-docs.json')
end
