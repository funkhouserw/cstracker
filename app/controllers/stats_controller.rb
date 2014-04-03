class StatsController < ApplicationController
  def index
    render json: PlayerPerformance.new(player.stats(1.month.ago, Time.now)).all_stats
  end

  def weapons
    render json: PlayerPerformance.new(player.stats(1.month.ago, Time.now)).all_weapon_kills
  end

  private
  def player
    player = Player.find(params.require(:player_id))
  end
end
