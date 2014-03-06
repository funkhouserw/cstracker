class PlayersController < ApplicationController
  def search
    #TODO: Determine if search is id or steam profile url.  If url, get steam id from profile url
    redirect_to :action => "show", :id => params.require(:steam_id)
  end

  def show
    @player = Player.find_or_create_by(steam_id: params.require(:id))
    flash[:error] = "Could not find a player by that id." unless @player
  end
end
