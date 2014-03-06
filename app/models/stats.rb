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
    raise "#{name} is not a weapon." if !WEAPONS.include?(name)
    WeaponStat.new(name,
      data["total_shots_" + name] || 0,
      data["total_hits_" + name] || 0,
      data["total_kills_" + name] || 0)
  end

  def kd
    if (total_deaths == 0)
      1
    else
      total_kills.to_f / total_deaths.to_f
    end
  end

  def headshot_percentage
    total_kills == 0 ? 0 : total_kills_headshot.to_f / total_kills.to_f
  end

  def method_missing(sym, *args, &block)
    data[sym.to_s] || super(sym, *args, &block)
  end

  def respond_to?(sym, include_private = false)
    data.try(:[], sym.to_s) != nil || super(sym, include_private)
  end

  WeaponStat = Struct.new(:name, :shots, :hits, :kills) do
    def accuracy
      return 0 if shots == 0
      hits / shots.to_f
    end

    def shots_per_kill
      return 0 if kills == 0 || shots == 0
      shots / kills.to_f
    end
  end
end
