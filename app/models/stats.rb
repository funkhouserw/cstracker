class Stats
  attr_reader :data, :total_kills, :total_deaths, :weapons

  WEAPONS = [
    "knife",
    "hegrenade",
    "glock",
    "deagle",
    "elite",
    "fiveseven",
    "xm1014",
    "mac10",
    "ump45",
    "p90",
    "awp",
    "ak47",
    "aug",
    "famas",
    "g3sg1",
    "m249",
    "hkp2000",
    "p250",
    "sg556",
    "scar20",
    "ssg08",
    "mp7",
    "mp9",
    "nova",
    "negev",
    "sawedoff",
    "bizon",
    "tec9",
    "mag7",
    "m4a1",
    "galilar",
    "molotov",
    "taser"
  ]


  def initialize(data_hash)
    parse(data_hash)
  end

  def weapon(name)
    {
      :shots => data["total_shots_" + name],
      :hits => data["total_hits_" + name],
      :kills => data["total_kills_" + name]
    }
  end

  def kd
    total_kills.to_f / total_deaths.to_f
  end

  private
  def parse(data_hash)
    @data = data_hash.each_with_object({}) { |stat, hsh| hsh[stat["name"]] = stat["value"] }
    @total_kills = data["total_kills"]
    @total_deaths = data["total_deaths"]
  end
end
