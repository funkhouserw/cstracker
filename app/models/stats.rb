class Stats
  include Mongoid::Document
  field :data, type: Hash
  field :player_id, type: Integer
  field :fetched_at, type: DateTime, default: ->{ DateTime.now }
  index({ player_id: 1 }, { name: "player_id_index" })

  def weapon(name)
    raise "#{name} is not a weapon." if !self.class.weapons.include?(name)
    WeaponStat.new(name,
      data["total_shots_" + name] || 0,
      data["total_hits_" + name] || 0,
      data["total_kills_" + name] || 0)
  end

  def kd
    total_deaths == 0 ? 1 : total_kills.to_f / total_deaths.to_f
  end

  def accuracy
    total_shots_fired == 0 ? 1 : total_shots_hit.to_f / total_shots_fired.to_f
  end

  def damage_per_shot
    total_damage_done == 0 ? 1 : total_damage_done.to_f / total_shots_hit.to_f
  end

  def win_percentage
    total_rounds_played == 0 ? 1 : total_wins.to_f / total_rounds_played.to_f
  end

  def headshot_percentage
    total_kills == 0 ? 0 : total_kills_headshot.to_f / total_kills.to_f
  end

  def weapons_by_kills
    self.class.weapons.keys.map { |x| self.weapon(x) }.sort_by { |x| -x.kills }
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

  def self.weapons
    Rails.configuration.weapons["weapons"]
  end
end
