require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module OnRuby
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extensions)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = :cache_expiration

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Berlin"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.locale = config.i18n.default_locale = :de
    config.available_locales = [:de, :en]
    config.enforce_available_locales = true

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.log_tags = [
      :host,
      lambda { |request| "#{request.uuid}"[0..15] },
      lambda { |request| "#{request.cookie_jar["_on_ruby_session"]}"[0..15] },
    ]

    # Enable the asset pipeline
    config.assets.initialize_on_precompile = false

    # Version of your assets, change this if you want to expire all your assets.
    config.assets.version = '1.0'

    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    config.assets.precompile += %w(labels/*)

    config.middleware.insert_before "Rails::Rack::Logger", "DisableAssetsLogger"

    # Configure generators.
    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec, :fixture => true, :views => false
      g.integration_tool :rspec, :fixture => true, :views => true
      g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
      g.stylesheet_engine = :sass
    end
  end
end
