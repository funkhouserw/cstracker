SteamStatTracker::Application.config.secret_key_base = if Rails.env.development? || Rails.env.test?
	('x' * 30)
else
	ENV['SECRET_TOKEN']
end