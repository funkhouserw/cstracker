desc "Sync steam stats for recently logged in users"
task :sync_stats => :environment do
  Player.where(:last_viewed.gte => 1.week.ago).each do |player|
    begin
      player.latest_stats
    rescue
    end
  end
end

desc "Clean out old stats"
task :remove_stale_stats => :environment do
  Stats.where(:fetched_at.lt => 2.month.ago).delete_all
end
