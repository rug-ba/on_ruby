OnRuby::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  # config.serve_static_assets = false
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=31536000"
  # Don't fallback to assets pipeline if a precompiled asset is missed
  # config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Compress both stylesheets and JavaScripts
  config.assets.js_compressor  = :uglifier

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
  config.action_dispatch.x_sendfile_header = nil # http://devcenter.heroku.com/articles/rails31_heroku_cedar#the_asset_pipeline

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store, ENV["MEMCACHIER_SERVERS"], {username: ENV["MEMCACHIER_USERNAME"], password: ENV["MEMCACHIER_PASSWORD"]}

  client = Dalli::Client.new(ENV["MEMCACHIER_SERVERS"], username: ENV["MEMCACHIER_USERNAME"], password: ENV["MEMCACHIER_PASSWORD"], value_max_bytes: 10485760, expires_in: 1.day)
  config.action_dispatch.rack_cache = {
    :metastore    => client,
    :entitystore  => client
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => 'smtp.sendgrid.net',
    :port                 => '587',
    :authentication       => :plain,
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :domain               => 'heroku.com',
    :enable_starttls_auto => true
  }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Set the default host for production
  config.default_host = 'onruby.de'

  config.middleware.use "CookieDomain", ".onruby.de"

  config.middleware.use ExceptionNotification::Rack, {
    email: {
      :email_prefix         => "[ERROR] ",
      :sender_address       => %{"error-notifier" <onruby@googlemail.com>},
      :exception_recipients => %w{onruby@googlemail.com}
    }
  }
end
