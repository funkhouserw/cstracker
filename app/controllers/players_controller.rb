class PlayersController < ApplicationController
  def search
    id = ApplicationHelper.steam_id64_from_url(params.require(:profile_url))
    id ||= Player.init_from_url(params.require(:profile_url)).steam_id
    redirect_to :action => :show, :id => id

    rescue
    flash[:error] = "Could not find a player from that url."
    render "welcome/index"
  end

  def show
    @player = Player.find_by(steam_id: params.require(:id))
    @player ||= Player.init_from_steam_id(params.require(:id).to_i)
    @player.update_attributes(last_viewed: Time.now)

    rescue
    flash[:error] = "Could not find a player from that id."
    render "welcome/index"
  end
end
