class Stats
  include Mongoid::Document
  field :data, type: Hash
  field :player_id, type: Integer
  field :fetched_at, type: DateTime, default: ->{ DateTime.now }
  index({ player_id: 1 }, { name: "player_id_index" })

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

  def total_kills
    data["total_kills"]
  end

  def total_deaths
    data["total_deaths"]
  end
end
