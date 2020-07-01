# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector::ContainerSet
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @containers = [] # NOTE: we use Array cuz we need an ordered set
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

  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? containes.each(&block) : containers.each }
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
