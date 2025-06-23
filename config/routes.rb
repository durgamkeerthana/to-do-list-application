Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'tasks#index', as: :authenticated_root
  end

  unauthenticated do
    root to: redirect('/users/sign_in')
  end

  resources :tasks do
    member do
      patch :toggle
    end
  end
end
