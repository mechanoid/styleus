require 'ostruct'

module Styleus
  class Engine < ::Rails::Engine
    initializer 'config.assets.precompile' do |app|
      #  # All assets required by templates provided by this engine
      #  # must be added here for precompilation.
      app.config.assets.precompile += ['styleus.css']
    end


    class Configuration < OpenStruct
      def to_s
        instance_variable_get(:@table).to_s
      end

      def inspect
        to_s
      end
    end
  end
end
