Rails.application.routes.draw do
  namespace(:api) do
    namespace(:v1) do
      post('signup', to: 'users#create')
      put('activate', to: 'users#update')
      delete('withdraw', to: 'users#destroy')

      post('login', to: 'user_token#create')

      resources(:categories, except: [:show])
    end
  end
end
