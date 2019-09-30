Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/:id' => 'short_links#show'
  post '/short_link' => 'short_links#create'
  get '/:id/analytics' => 'short_links#analytics', as: :analytics_path
  resources :short_links, only: [:show]
end
