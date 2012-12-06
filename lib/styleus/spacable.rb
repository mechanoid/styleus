module Styleus
  module Spacable
    extend ActiveSupport::Concern

    module ClassMethods
      def spaces(*collection)
        @spaces ||= []
        return @spaces if collection.empty?
        @spaces.concat(collection).uniq! if collection.respond_to? :to_ary
        @spaces
      end
    end
  end
end