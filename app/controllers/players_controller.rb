class PlayersController < ApplicationController
  def search
    id = ApplicationHelper.steam_id64_from_url(params.require(:profile_url))
    id ||= Player.init_from_url(params.require(:profile_url)).steam_id
    redirect_to :action => :show, :id => id

    rescue
    flash[:error] = "Could not find a player by that id."
    render "welcome/index"
  end

  def show
    @player = Player.find_by_steam_id(params.require(:id))

    rescue
    flash[:error] = "Could not find a player by that id."
    render "welcome/index"
  end
end
