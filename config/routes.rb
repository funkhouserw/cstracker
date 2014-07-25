SteamStatTracker::Application.routes.draw do
  resources :players, :only => [:show] do
    collection do
      post 'search'
    end

    resources :stats, :only => [:index] do
      collection do
        get 'weapons'
        get 'operation_coins'
      end
    end
  end

  match 'faq', to: "welcome#faq", :via => [:get], :as => "faq"
  root to: "welcome#index"
end
