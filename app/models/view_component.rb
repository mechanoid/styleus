class ViewComponent < Base
  with_attributes :headline, :partial_path

  # id is used as anchor id in the anchor menu,
  # so it has to be a uid.
  # TODO: make sure the uid-ness :)
  def id
    headline.underscore
  end

  class << self
    def components
      @components ||= []
    end

    def from_hashes(hashes)
      components.clear
      hashes.each { |comp_hash| components << ViewComponent.new(comp_hash) }
      components
    end
  end
end