Dummy::Application.routes.draw do
  root to: "home#index"

  resources :categories
  resources :products do
    get :recent, on: :collection
    resources :reviews
  end
end
