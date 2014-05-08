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

  def match_result(_result)
    if _result == -1
      "LOSS"
    elsif _result == 0
      "TIE"
    else
      "WIN"
    end
  end

  def weapons_by_group
    @weapon_groups ||= begin
      result = {}
      Stats.weapons.each do |id, values|
        result[values["group"]] ||= []
        result[values["group"]] << id
      end
      result
    end
  end
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
end
