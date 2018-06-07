Rails.application.routes.draw do
  get 'terms', to: 'terms#index', as: :terms
  get 'privacy', to: 'privacies#index', as: :privacy
  get '/confirm/:id', to: 'posts#confirm', as: :confirm
  resources :posts, only: [:create, :show, :edit]
  root to: "posts#create"
  get '/twitter/:id', to: 'posts#twitter', as: :twitter
  post '/callback' => 'linebot#callback'
  post '/line' => 'posts#line'
end
