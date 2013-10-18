Dummy::Application.routes.draw do
  root to: "home#index"
  
  get "about" => "home#about", as: :about

  resources :categories
  resources :products do
    get :recent, on: :collection
    resources :reviews
  end
end
