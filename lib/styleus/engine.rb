module Styleus
  class Engine < ::Rails::Engine
    initializer 'styleus.assets.precompile' do |app|
      # All assets required by templates provided by this engine
      # must be added here for precompilation.
      app.config.assets.precompile += ['styleus.css']
    end
  end
end
