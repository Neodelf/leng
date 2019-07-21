Rails.application.routes.draw do
  resources :main, only: :index
  resources :articles, only: %i[create show index]

  resources :words, only: [] do
    collection do
      get :check
      get :translation
      get :source
    end
  end

  root to: 'main#index'
end
