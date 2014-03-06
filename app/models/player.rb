class Player < ActiveRecord::Base
  TIME_UNTIL_FETCH = 1.hour
  before_validation :validate_steam_id, :on => :create

  def latest_stats
    @latest_stats ||= begin
      stats = Stats.where(:player_id => id).last
      if stats.nil? || stats.fetched_at < TIME_UNTIL_FETCH.ago
        stats = SteamApiService.new(self).download_player_stats
      end
      stats
    end
  end

  def stats(start_time=nil, end_time=nil)
    params = {}
    params[:fetched_at.gte] = start_time if start_time
    params[:fected_at.lte] = end_time if end_time

    Stats.where(params.merge(:player_id => id))
  end

  private
  def validate_steam_id
    # TODO: Validate with steam
  end
end
