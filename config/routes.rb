Rails.application.routes.draw do
  devise_for :students
=begin
  devise_scope :students do
    root :to => "devise/sessions#new"
  end
=end

  authenticated :student do
    root 'users#record', as: :authenticated_root
  end

  devise_scope :student do
    root :to => "devise/sessions#new"
    get '/students/sign_out' => 'devise/sessions#destroy'
  end

  post '/login' => 'users#login'
  get 'users/record' => 'users#record'
  get 'users/teacher'
  get 'users/index', as:"users_index"
  get 'users/show/:id' => 'users#show', as:"users_show"
  get 'users/new'
  get 'users/edit/:id' => 'users#edit', as:"users_edit"
  delete 'users/destroy/:id' => 'users#destroy', as:"users_destroy"
  post 'users/new' => 'users#create', as:"students"
  # patch 'users/edit/update' => 'users#update'
  put 'users/edit/:id' => 'users#update', as:"users_edit_update"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
