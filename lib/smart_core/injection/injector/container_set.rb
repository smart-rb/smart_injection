# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector::ContainerSet
  require_relative 'container_set/adding_listener'

  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @containers = [] # NOTE: we use Array cuz we need an ordered set
    @adding_listeners = []
    @access_lock = SmartCore::Engine::Lock.new
  end

  # @param container [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(container)
    thread_safe { append_container(container) }
  end
  alias_method :<<, :add

  # @param listener [Block]
  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def listen_addings(&listener)
    thread_safe { add_adding_listener(listener) }
  end

  # @param block [Block]
  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? containers.each(&block) : containers.each }
  end

  # @param block [Block]
  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def reverse_each(&block)
    thread_safe { block_given? ? containers.reverse_each(&block) : containers.reverse_each }
  end

  # @return [Array<SmartCore::Container>]
  #
  # @api private
  # @since 0.1.0
  def list
    thread_safe { containers.dup }
  end

  private

  # @return [Array<SmartCore::Container>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :containers

  # @return [Array<SmartCore::Injection::Injector::ContainerSet::AddingListener>]
  attr_reader :adding_listeners

  # @param listener [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_adding_listener(listener)
    adding_listeners << SmartCore::Injection::Injector::ContainerSet::AddingListener.new(listener)
  end

  # @param container [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def append_container(container)
    # NOTE:
    #   - #concant is used to prevent container duplications in ordered set;
    #   - @containers should have an ordered unified container list;
    containers.concat([container])
    adding_listeners.each { |listener| listener.notify(container) }
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
