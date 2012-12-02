Rails.application.config.before_configuration do |app|

  # initialize styleus configuration
  app.config.styleus = Styleus::Engine::Configuration.new unless app.config.respond_to? :styleus

  # some defaults
  app.config.styleus.maximum_screen_size = 1680
  app.config.styleus.use_default_dimensions = true
end
