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
        resources(:ate_foods, only: [:index, :create])
        resources(:dishes, only: [:index, :create])
      end
      resources(:bodies) do
        member do
          put('weight')
          put('percentage')
        end
      end
      resources(:ate_foods, only: [:update, :destroy])
      resources(:dishes, only: [:update, :destroy])
      resources(:charts) do
        collection do
          [:weight, :percentage, :calory, :protein, :fat, :carbonhydrate].each do |attr_name|
            send(:get, "date_#{attr_name}")
            send(:get, "month_#{attr_name}")
          end
        end
      end
    end
  end
end
