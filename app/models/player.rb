class Player < ActiveRecord::Base
  TIME_UNTIL_FETCH = 1.hour

  def latest_stats
    @latest_stats ||= begin
      stats = Stats.where(:player_id => id).last
      if stats.nil? || stats.fetched_at < TIME_UNTIL_FETCH.ago
        stats = SteamApiService.new(self).download_player_stats
      end
      stats
    end
  end
end
