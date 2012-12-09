module Styleus
  class ViewComponent < Styleus::Base
    with_attributes :headline, :partial_path, :helper

    # id is used as anchor id in the anchor menu,
    # so it has to be a uid.
    # TODO: make sure the uid-ness :)
    def id
      headline.underscore.gsub(/ /, '_')
    end

    def helper?
      !!helper
    end

    class << self
      def components
        @components ||= []
      end

      def from_hashes(hashes)
        components.clear
        hashes.each { |comp_hash| components << new(comp_hash) }
        components
      end
    end
  end
end