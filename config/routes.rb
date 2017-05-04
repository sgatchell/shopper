Rails.application.routes.draw do
  resources :applicants, only: [:create, :update, :show, :new] do
    collection do
      get :landing
    end
    member do
      get :background_check
    end
  end
  resources :funnels, only: [:index]
end
