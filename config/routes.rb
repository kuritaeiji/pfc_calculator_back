Rails.application.routes.draw do
  namespace(:api) do
    namespace(:v1) do
      post('signup', to: 'users#create')
      put('activate', to: 'users#update')
      delete('withdraw', to: 'users#destroy')

      post('login', to: 'user_token#create')

      resources(:categories, except: [:show])
      resources(:foods, except: [:show])
      resources(:days, param: :date, only: [:create]) do
        resources(:bodies, only: [:create])
      end
      resources(:bodies) do
        member do
          put('weight')
          put('percentage')
        end
      end
    end
  end
end
