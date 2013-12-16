TeamStatusApp::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => 'users'}

  devise_scope :user do
    resources :users, :only => [:show]
  end

  resources :groups do
    get 'refresh_statuses', :to => 'groups#refresh_statuses'

    resources :statuses do
      put 'switch_tracking', :on => :member
    end

    resources :agendas
  end

  root :to => 'home#index'

end
