class PlayerPerformance
  attr_reader :stats

  def initialize(_stats)
    @stats = _stats.sort_by { |x| x.fetched_at }
  end

  def all_stats
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    hsh["weapons"] = all_weapon_kills
    hsh["general"]["rounds"] = rounds
    hsh["general"]["matches"] = matches
    hsh["general"]["kd"] = kd
    hsh["general"]["accuracy"] = accuracy
    hsh
  end
  
  def all_weapon_kills
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    Stats.weapons.keys.each do |weapon_id|
      stat_by_day("total_kills_#{weapon_id}").each do |day, value|
        hsh[day][weapon_id] = value
      end
    end
    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def rounds
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stats_by_day("total_wins", "total_rounds_played").each do |day, values|
      hsh[day]["wins"] = values["total_wins"]
      hsh[day]["losses"] = values["total_rounds_played"] - hsh[day]["wins"]
    end

    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def matches
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stats_by_day( "total_matches_won",
                  "total_matches_played",
                  "total_gg_matches_played",
                  "total_gg_matches_won").each do |day, values|
      hsh[day]["wins"] = values["total_matches_won"] - values["total_gg_matches_won"]
      hsh[day]["losses"] = values["total_matches_played"] - values["total_gg_matches_played"]
      hsh[day]["losses"] -= hsh[day]["wins"]
    end

    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def kd
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stats_by_day("total_kills", "total_deaths").each do |day, values|
      hsh[day]["kills"] = values["total_kills"]
      hsh[day]["deaths"] = values["total_deaths"]
      hsh[day]["kd"] = values["total_deaths"] == 0 ? 0 : values["total_kills"].to_f / values["total_deaths"].to_f
    end

    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def accuracy
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stats_by_day("total_shots_hit", "total_shots_fired").each do |day, values|
      hsh[day]["shots_hit"] = values["total_shots_hit"]
      hsh[day]["shots_fired"] = values["total_shots_fired"]
      hsh[day]["accuracy"] = values["total_shots_fired"] == 0 ? 0 : values["total_shots_hit"].to_f / values["total_shots_fired"].to_f
    end

    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def stat_by_day(_stat)
    return {} if stats.count == 0

    results = Hash.new(0)
    stats.each_with_index do |stat, index|
      if index > 0
        point = stat.send(_stat.to_sym)
        total = point - stats[index - 1].send(_stat.to_sym)
        date = Time.at(stat.fetched_at.to_i - ((stat.fetched_at.to_i - stats[index - 1].fetched_at.to_i) / 2)).to_date
        results[date] += total
      end
    end
    results
  end

  def stats_by_day(*attributes)
    return {} if stats.count == 0

    results = hsh = Hash.new {|hsh, key| hsh[key] = Hash.new(0) }
    stats.each_with_index do |stat, index|
      if index > 0
        attributes.each do |attribute|
          point = stat.send(attribute.to_sym)
          total = point - stats[index - 1].send(attribute.to_sym)
          date = Time.at(stat.fetched_at.to_i - ((stat.fetched_at.to_i - stats[index - 1].fetched_at.to_i) / 2)).to_date
          results[date][attribute] += total
        end
      end
    end
    results
  end
end
