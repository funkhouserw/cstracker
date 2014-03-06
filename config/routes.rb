SteamStatTracker::Application.routes.draw do
  resources :players, :only => [:show] do
    collection do
      get 'search'
    end
  end

  root to: "welcome#index"
end
