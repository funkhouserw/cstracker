class PlayersController < ApplicationController
  def search
    #TODO: Determine if search is id or steam profile url.  If url, get steam id from profile url
    @player = Player.init_from_url(params.require(:profile_url))
    render "show"

    rescue
    flash[:error] = "Could not find a player by that id."
    render "welcome/index"
  end

  def show
    @player = Player.find(id: params.require(:id))

    rescue
    flash[:error] = "Could not find a player by that id."
    render "welcome/index"
  end
end
