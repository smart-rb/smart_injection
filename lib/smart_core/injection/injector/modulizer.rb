# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Injection::Injector::Modulizer
  class << self
    # @param containers [Array<SmartCore::Container>]
    # @return [Module]
    #
    # @api private
    # @since 0.1.0
    def with_containers(containers)
      prevent_inconsistency!(containers)
      build_container_injectable_module(containers)
    end

    # @param base_klass [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inject_to(base_klass)
      base_klass.extend(::SmartCore::Injection::DSL)
    end

    private

    # @param containers [Array<SmartCore::Container>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_inconsistency!(containers)
      unless containers.is_a?(Array) && containers.all? { |cont| cont.is_a?(SmartCore::Container) }
        raise(SmartCore::Injection::ArgumentError, <<~ERROR_MESSAGE)
          Injectable containers should be a type of SmartCore::Container
        ERROR_MESSAGE
      end
    end

    # @param containers [Array<SmartCore::Container>]
    # @return [Module]
    #
    # @api private
    # @since 0.1.0
    def build_container_injectable_module(containers)
      Module.new do
        define_singleton_method :included do |base_klass|
          base_klass.extend(::SmartCore::Injection::DSL)
          base_klass.register_container(*containers)
        end
      end
    end
  end
end
