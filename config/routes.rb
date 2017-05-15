Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/get_newcomer_stories', action: :get_newcomers, controller: 'api'
end
