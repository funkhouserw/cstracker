class PlayerPerformance
  attr_reader :stats

  def initialize(_stats)
    @stats = _stats.sort_by { |x| x.fetched_at }
  end

  def all_weapon_kills
    hsh = Hash.new {|hsh, key| hsh[key] = {} }
    Stats::WEAPONS.each do |weapon_id|
      stat_by_day("total_kills_#{weapon_id}").each do |day, value|
        hsh[day][weapon_id] = value
      end
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
