class ViewComponent < Base
  with_attributes :headline, :partial_path

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