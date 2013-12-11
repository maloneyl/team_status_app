TeamStatusApp::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => 'users'}

  devise_scope :user do
    resources :users, :only => [:show]
  end

  resources :groups do
    resources :statuses do
      put 'switch_tracking', :on => :member
    end
  end

  root :to => 'home#index'

end
