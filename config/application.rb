require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
#require "active_resource/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SteamStatTracker
  class Application < Rails::Application
    if File.exists?(File.join(__dir__, 'steam.yml'))
      config.steam = YAML::load_file(File.join(__dir__, 'steam.yml'))
    end

    config.weapons = YAML::load_file(File.join(__dir__, 'weapons.yml'))
    config.maps = YAML::load_file(File.join(__dir__, 'maps.yml'))
    config.operations = YAML::load_file(File.join(__dir__, 'operations.yml'))
    config.autoload_paths += %W(#{config.root}/app/services)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
