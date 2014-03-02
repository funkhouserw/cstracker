class Player < ActiveRecord::Base
  def latest_stats
    @latest_stats ||= begin
      Stats.new(SteamApiService.new(steam_id).player_stats)
    end
  end
end
