Rails.application.routes.draw do
  namespace(:api) do
    namespace(:v1) do
      post('signup', to: 'users#create')
      put('activate', to: 'users#update')
      get('current_user', to: 'users#show')

      post('login', to: 'user_token#create')
    end
  end
end
