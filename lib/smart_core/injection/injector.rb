# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector
  require_relative 'injector/container_set'
  require_relative 'injector/injection_settings'
  require_relative 'injector/modulizer'

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

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject
    thread_safe {}
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def inject_static
    thread_safe {}
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
