class StatsController < ApplicationController
  def index
    player = Player.find(params.require(:player_id))
    render json: PlayerPerformance.new(player.stats(1.month.ago, Time.now)).stat_by_day("total_kills")
  end
end
