TeamStatusApp::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => 'users'}

  devise_scope :user do
    resources :users, :only => [:show]
  end

  resources :groups do
    get 'get_statuses', :to => 'groups#get_statuses'

    resources :statuses do
      put 'switch_tracking', :on => :member
    end

    resources :agendas

    put 'remove_member/:user_id', :to => 'groups#remove_member'
    get 'leave_group', :to => 'groups#leave_group'
  end

  root :to => 'home#index'

end
