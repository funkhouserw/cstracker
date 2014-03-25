SteamStatTracker::Application.routes.draw do
  resources :players, :only => [:show] do
    collection do
      post 'search'
    end

    resources :stats, :only => [:index] do
      collection do
        get 'weapons'
      end
    end
  end

  root to: "welcome#index"
end
