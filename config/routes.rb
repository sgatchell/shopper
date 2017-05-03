Rails.application.routes.draw do
  resources :applicants, only: [:create, :update, :show, :new] do
    collection do
      get :landing
    end
  end
  resources :funnels, only: [:index]
end
