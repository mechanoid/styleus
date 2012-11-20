class ComponentList

  def components
    @components ||= []
  end

  class << self
    def from_hashes(hashes)
      @component_list = ComponentList.new
      hashes.each { |comp_hash| @component_list.components << Component.new(comp_hash)}
      @component_list
    end
  end

end