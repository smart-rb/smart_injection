# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector
  require_relative 'injector/container_set'
  require_relative 'injector/injection_settings'
  require_relative 'injector/modulizer'
  require_relative 'injector/strategies'

  # @param injectable [Class, Module]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(injectable)
    @injectable = injectable
    @linked_containers = SmartCore::Injection::Injector::ContainerSet.new
    @access_lock = SmartCore::Engine::Lock.new
  end

  # @param imports [Hash<String|Symbol,String>]
  # @param memoize [Boolean]
  # @param access [Symbol]
  # @param bind [Symbol]
  # @param from [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject(imports, memoize, access, bind, from)
    thread_safe { inject_instance_method(imports, memoize, access, bind, from) }
  end

  # @param imports [Hash<String|Symbol,String>]
  # @param memoize [Boolean]
  # @param access [Symbol]
  # @param bind [Symbol]
  # @param from [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject_static(imports, memoize, access, bind, from)
    thread_safe { inject_class_method(imports, memoize, access, bind, from) }
  end

  # @param containers [Array<SmartCore::Container>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register_container(containers)
    thread_safe { link_container(containers) }
  end

  # @return [Array<SmartCore::Container>]
  #
  # @api private
  # @since 0.1.0
  def associated_containers
    thread_safe { linked_containers.list }
  end

  private

  # @return [Class, Module]
  #
  # @api private
  # @since 0.1.0
  attr_reader :injectable

  # @return [Array<SmartCore::Container>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :linked_containers

  # @param imports [Hash<String|Symbol,String>]
  # @param memoize [Boolean]
  # @param access [Symbol]
  # @param bind [Symbol]
  # @param from [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject_instance_method(imports, memoize, access, bind, from)
    SmartCore::Injection::Injector::Strategies::MethodInjection.inject_instance_method(
      SmartCore::Injection::Injector::InjectionSettings.new(
        injectable,
        linked_containers,
        imports,
        memoize: memoize,
        access: access,
        bind: bind,
        from: from
      )
    )
  end

  # @param imports [Hash<String|Symbol,String>]
  # @param memoize [Boolean]
  # @param access [Symbol]
  # @param bind [Symbol]
  # @param from [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject_class_method(imports, memoize, access, bind, from)
    SmartCore::Injection::Injector::Strategies::MethodInjection.inject_class_method(
      SmartCore::Injection::Injector::InjectionSettings.new(
        injectable,
        linked_containers,
        imports,
        memoize: memoize,
        access: access,
        bind: bind,
        from: from
      )
    )
  end

  # @param containers [Array<SmartCore::Container>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def link_container(containers)
    containers.each do |container|
      linked_containers.add(container)
    end
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
