# frozen_string_literal: true

# @api public
# @since 0.1.0
module SmartCore::Injection::DSL
  class << self
    # @param base_klass [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(
        :@__smart_injection_injector__,
        SmartCore::Injection::Injector.new(base_klass)
      )
      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @param imports [Hash<String|Symbol,String>]
    # @option memoize [Boolean]
    # @option access [Symbol]
    # @option bind [Symbol]
    # @option from [NilClass, SmartCore::Container]
    # @return [void]
    #
    # @api public
    # @sincd 0.1.0
    def import(
      imports,
      memoize: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_MEMOIZE,
      access: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_ACCESS,
      bind: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_BINDING_STRATEGY,
      from: SmartCore::Injection::Injector::InjectionParameters::EMPTY_CONTAINER_DESTINATION
    )
      __smart_injection_injector__.inject(imports, memoize, access, bind, from)
    end

    # @param imports [Hash<String|Symbol,String>]
    # @option memoize [Boolean]
    # @option access [Symbol]
    # @option bind [Symbol]
    # @option from [NilClass, SmartCore::Container]
    # @return [void]
    #
    # @api public
    # @sincd 0.1.0
    def import_static(
      imports,
      memoize: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_MEMOIZE,
      access: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_ACCESS,
      bind: SmartCore::Injection::Injector::InjectionParameters::DEFAULT_BINDING_STRATEGY,
      from: SmartCore::Injection::Injector::InjectionParameters::EMPTY_CONTAINER_DESTINATION
    )
      __smart_injection_injector__.inject_static(imports, memoize, access, bind, from)
    end

    # @param containers [Array<SmartCore::Container>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def register_container(*containers)
      __smart_injection_injector__.register_container(containers)
    end

    # @return [Array<SmartCore::Container>]
    #
    # @api public
    # @since 0.1.0
    def linked_containers
      __smart_injection_injector__.associated_containers
    end

    private

    # @return [SmartCore::Injection::Injector]
    #
    # @api private
    # @since 0.1.0
    attr_reader :__smart_injection_injector__
  end
end
