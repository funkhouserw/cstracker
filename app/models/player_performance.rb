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
  
  def top_fives
    # WEAPONS
    weapon_hash = Hash.new
    Stats.weapons.keys.each do |weapon_id|
      weapon_hash[Stats.weapons[weapon_id]["name"]] = stats.last.data["total_kills_#{weapon_id}"]
    end
    weapon_hash = weapon_hash.sort_by {|k, v| v}
    weapon_hash.reverse!
    # MAPS
    map_hash = Hash.new
    Stats.maps["maps"].keys.each do |map_id|
      Stats.maps["modes"].keys.each do |mode_id|
        current_map_plays = stats.last.data["total_rounds_map_#{mode_id}_#{map_id}"]
        if current_map_plays != nil
          unless map_hash[Stats.maps["maps"][map_id]["name"]] != nil && current_map_plays < map_hash[Stats.maps["maps"][map_id]["name"]]
            map_hash[Stats.maps["maps"][map_id]["name"]] = current_map_plays
          end
        end
      end
    end
    map_hash = map_hash.sort_by {|k, v| v}
    map_hash.reverse!
    
    { "weapons" => weapon_hash, "maps" => map_hash }
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
    stat_by_day("total_wins").each { |day, value| hsh[day]["wins"] = value }
    stat_by_day("total_rounds_played").each { |day, value| hsh[day]["losses"] = value - (hsh[day]["wins"] || 0) }
    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def matches
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stat_by_day("total_matches_won").each { |day, value| hsh[day]["wins"] = value }
    stat_by_day("total_matches_played").each { |day, value| hsh[day]["losses"] = value - (hsh[day]["wins"] || 0) }
    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def kd
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stat_by_day("total_kills").each { |day, value| hsh[day]["kills"] = value }
    stat_by_day("total_deaths").each do |day, value|
      hsh[day]["deaths"] = value
      hsh[day]["kd"] = value == 0 ? 0 : hsh[day]["kills"].to_f / value.to_f
    end
    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def accuracy
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    stat_by_day("total_shots_hit").each { |day, value| hsh[day]["shots_hit"] = value }
    stat_by_day("total_shots_fired").each do |day, value|
      hsh[day]["shots_fired"] = value
      hsh[day]["accuracy"] = value == 0 ? 0 : hsh[day]["shots_hit"].to_f / value.to_f
    end
    hsh.each_with_object([]) { |(k, v), array| array << v.merge("d" => k) }
  end

  def stat_by_day(_stat)
    return {} if stats.count == 0

    results = Hash.new(0)
    stats.each_with_index do |stat, index|
      if index > 1
        point = stat.send(_stat.to_sym)
        total = point - stats[index - 1].send(_stat.to_sym)
        date = Time.at(stat.fetched_at.to_i - ((stat.fetched_at.to_i - stats[index - 1].fetched_at.to_i) / 2)).to_date
        results[date] += total
      end
    end
    results
  end
end
