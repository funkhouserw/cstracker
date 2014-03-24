SteamStatTracker::Application.routes.draw do
  resources :players, :only => [:show] do
    collection do
      post 'search'
    end

    resources :stats, :only => [:index]
  end

  root to: "welcome#index"
end
