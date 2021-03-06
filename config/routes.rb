Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

  devise_for :students, :controllers => {
      :registrations => 'students/registrations'
  }

=begin
  devise_scope :students do
    root :to => "devise/sessions#new"
  end
=end

  authenticated :student do
    root 'users#show_record', as: :authenticated_root
  end

  devise_scope :student do
    root :to => "devise/sessions#new"
    get '/students/sign_out' => 'devise/sessions#destroy'
    get '/students/sign_up' => 'devise/registrations#new'
  end

  post 'users/login' => 'users#login'
  get 'users/show_record' => 'users#show_record'
  post 'users/show_record' => 'users#show_record'
  get 'users/show_all' => 'users#show_all'
  post 'users/show_all' => 'users#show_all'
  get 'users/teacher'
  post 'users/teacher' => 'users#logout'
  get 'users/index', as:"users_index"
  get 'users/show/:id' => 'users#show', as:"users_show"
  get 'users/new_record/:id' => 'users#new_record', as:"users_new_record"
  post 'users/new_record/:id' => 'users#add_record', as:"users_add_record"
  get 'users/edit_record/:id' => 'users#edit_record', as:"users_edit_record"
  post 'users/edit_record/:id' => 'users#update_record', as:"users_update_record"
  get 'users/new'
  get 'users/edit/:id' => 'users#edit', as:"users_edit"
  delete 'users/destroy/:id' => 'users#destroy', as:"users_destroy"
  # post 'users/new' => 'users#create', as:"students"
  # patch 'users/edit/update' => 'users#update'
  put 'users/edit/:id' => 'users#update', as:"users_update"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
