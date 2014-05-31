desc "Sync steam stats for recently logged in users"
task :sync_stats => :environment do
  Player.where(:last_viewed.gte => 1.week.ago).each do |player|
    player.latest_stats
  end
end