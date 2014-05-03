class Player < ActiveRecord::Base
  TIME_UNTIL_FETCH = 1.hour
  before_validation :validate_steam_id, :on => :create
  attr_accessor :community_steam_id

  def latest_stats
    @latest_stats ||= begin
      stats = Stats.where(:player_id => id).last
      if stats.nil? || stats.fetched_at < TIME_UNTIL_FETCH.ago
        stats = SteamApiService.new(self).download_player_stats
      end
      stats
    end
  end

  def latest_inventory
    @latest_inventory ||= begin
      inventory = Inventory.where(:player_id => id).last
      if inventory.nil? || inventory.fetched_at < TIME_UNTIL_FETCH.ago
        inventory = SteamApiService.new(self).download_player_inventory
      end
      inventory
    end
  end

  def stats(start_time=nil, end_time=nil)
    params = {}
    params[:fetched_at.gte] = start_time if start_time
    params[:fetched_at.lte] = end_time if end_time

    Stats.where(params.merge(:player_id => id))
  end

  def community_profile
    @community_steam_id ||= SteamId.new(steam_id.to_i)
  end


  def self.init_from_url(url)
    # Probably a waaayy better way to do this, but it'll do for now
    steam_id = /\/profiles\/(.*?)\//.match(url + "/").try(:[], 1)
    steam_id = steam_id.to_i if steam_id
    steam_id ||= /\/id\/(.*?)\//.match(url + "/").try(:[], 1)
    init_from_steam_id(steam_id)
  end

  def self.init_from_steam_id(steam_id)
    raise "Could not find steam id" if steam_id.nil?
    community_steam_id = SteamId.new(steam_id)
    player = Player.find_or_create_by(steam_id: community_steam_id.steam_id64)
    player.community_steam_id = community_steam_id
    return player
  end

  private
  def validate_steam_id
    # TODO: Validate with steam
  end
end
