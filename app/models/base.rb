# Provides a basic model, with attribute and
# naming capabilities.
# TODO: replace with ActiveModel::Model or something like that
class Base
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization

  def initialize(attributes)
    @attributes = attributes
  end

  def id
    nil
  end

  # as implemented as in ActiveRecord
  def to_key
    key = self.id
    [key] if key
  end

  private

  def attribute(attr)
    @attributes[attr.to_sym]
  end

  class << self
    def with_attributes(*attribute_names)
      define_attribute_methods attribute_names.map(&:to_s)
    end
  end
end