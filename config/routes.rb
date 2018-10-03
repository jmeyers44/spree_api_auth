Spree::Core::Engine.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resource :users, only: [] do
        post :sign_up
        post :sign_in
        post :recover
        get :me
      end
    end
  end
end
