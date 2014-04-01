module ApplicationHelper
  def self.steam_id64_from_url(url)
    steam_id = /\/profiles\/(.*?)\//.match(url + "/").try(:[], 1)
    if steam_id
      steam_id.to_i
    else
      nil
    end
  end

  def online_status_class(player)
    if player.community_profile.in_game?
      "in_game"
    elsif player.community_profile.online?
      "online"
    else
      "offline"
    end
  end
end
