class Stats
  include Mongoid::Document
  field :data, type: Hash
  field :fetched_at, type: DateTime, default: ->{ DateTime.now }
  belongs_to :player, index: true
  index({ player_id: 1 }, { name: "player_id_index" })

  def weapon(name)
    raise "#{name} is not a weapon." if !self.class.weapons.include?(name)
    WeaponStat.new(name,
      data["total_shots_" + name] || 0,
      data["total_hits_" + name] || 0,
      data["total_kills_" + name] || 0)
  end

  def map(name)
    MapStat.new(name,
      data["total_wins_map_#{name}"] || 0,
      data["total_rounds_map_#{name}"] || 0)
  end

  def kd
    total_deaths == 0 ? 1 : total_kills.to_f / total_deaths.to_f
  end

  def accuracy
    (total_shots_fired == 0 ? 1 : total_shots_hit.to_f / total_shots_fired.to_f) * 100
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

  def contribution_per_round
    total_rounds_played == 0 ? 1 : total_contribution_score.to_f / total_rounds_played.to_f
  end

  def total_hours_played
    total_time_played / 3600.0
  end

  def all_weapons
    self.class.weapons.keys.map { |x| self.weapon(x) }
  end

  def all_maps
    self.class.maps.keys.map { |x| self.map(x) }
  end

  def latest_match_result
    if last_match_wins.to_f / last_match_rounds.to_f < 0.5
      -1
    elsif last_match_wins.to_f / last_match_rounds.to_f == 0.5
      0
    else
      1
    end
  end

  def latest_match_kd
    last_match_deaths == 0 ? 0 : last_match_kills.to_f / last_match_deaths.to_f
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
      (hits / shots.to_f) * 100
    end

    def shots_per_kill
      return 0 if kills == 0 || shots == 0
      shots / kills.to_f
    end

    def as_json(options={})
      super(options).merge!(accuracy: accuracy, shots_per_kill: shots_per_kill, ui_name: Rails.configuration.weapons["weapons"][name]["name"])
    end
  end

  MapStat = Struct.new(:name, :wins, :played) do
    def losses
      played - wins
    end

    def win_percentage
      played == 0 ? 0.0 : wins.to_f / played.to_f
    end

    def as_json(options={})
      super(options).merge!(win_percentage: win_percentage, ui_name: Stats.maps[name]["name"])
    end
  end

  def self.weapons
    Rails.configuration.weapons["weapons"]
  end
  
  def self.maps
    Rails.configuration.maps["maps"]
  end
end
