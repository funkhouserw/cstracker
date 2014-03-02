class SteamApiService
  attr_reader :steam_id

  def initialize(steam_id)
    @steam_id = steam_id
  end

  def player_stats
    uri = URI("http://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/?appid=#{app_id}&key=#{api_key}&steamid=#{steam_id}")
    JSON.parse(Net::HTTP.get(uri))["playerstats"]["stats"]
  end

  def api_key
    Rails.configuration.steam["api_key"]
  end

  def app_id
    730 #CSGO
  end
end
