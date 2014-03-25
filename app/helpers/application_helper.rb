module ApplicationHelper
  def self.steam_id64_from_url(url)
    steam_id = /\/profiles\/(.*?)\//.match(url + "/").try(:[], 1)
    if steam_id
      steam_id.to_i
    else
      nil
    end
  end
end
