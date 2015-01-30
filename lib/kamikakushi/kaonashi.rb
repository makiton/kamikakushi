module Kamikakushi
  module Kaonashi
    extend ActiveSupport::Concern

    included do |base|
      cattr_reader :kamikakushi_parent_name

      base.reflect_on_all_associations(:belongs_to).map do |reflection|
        if reflection.klass.include?(Kamikakushi)
          class_variable_set('@@kamikakushi_parent_name', reflection.name)
        end
      end

      alias_method_chain :destroyed?, :kaonashi
    end

    def destroyed_with_kaonashi?
      search_root_parent.destroyed? || destroyed_without_kaonashi?
    end

    def search_root_parent
      kamikakushi_parent = self.__send__(kamikakushi_parent_name)
      return kamikakushi_parent unless kamikakushi_parent.respond_to?(:search_root_parent)
      kamikakushi_parent.search_root_parent
    end
  end
end
