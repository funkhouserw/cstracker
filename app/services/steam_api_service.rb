require 'net/http'

class SteamApiService
  attr_reader :player
  CSGO_APP_ID = 730

  def initialize(_player)
    @player = _player
  end

  def download_player_stats
    uri = URI("http://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/?appid=#{CSGO_APP_ID}&key=#{api_key}&steamid=#{player.steam_id}")
    raw_stats = JSON.parse(Net::HTTP.get(uri))
    raise NoStatsAvailableError if raw_stats.blank?
    player.stats.create(data: parse_stats(raw_stats["playerstats"]["stats"]))
  end

  def download_player_inventory
    uri = URI("http://api.steampowered.com/IEconItems_#{CSGO_APP_ID}/GetPlayerItems/v1/?key=#{api_key}&steamid=#{player.steam_id}")
    raw_stats = JSON.parse(Net::HTTP.get(uri))["result"]["items"]
    player.inventories.create(items: raw_stats)
  end

  private
  def api_key
    ENV['API_KEY'] || Rails.configuration.steam["api_key"]
  end

  def parse_stats(data_hash)
    data_hash.each_with_object({}) { |stat, hsh| hsh[stat["name"]] = stat["value"] }
  end
end

class NoStatsAvailableError < StandardError
end