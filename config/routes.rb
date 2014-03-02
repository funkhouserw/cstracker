SteamStatTracker::Application.routes.draw do
  resources :players, :only => [:index, :show] do
    collection do
      get 'search'
    end
  end

  root to: "players#index"
end
