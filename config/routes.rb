Rails.application.routes.draw do
  get '/confirm/:id', to: 'posts#confirm', as: :confirm
  resources :posts, only: [:create, :show, :edit, :update]
  root to: "posts#new"
end
