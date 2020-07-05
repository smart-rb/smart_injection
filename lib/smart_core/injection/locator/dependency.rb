# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Locator::Dependency
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @binded = false
    @value = nil
    @barrier = SmartCore::Engine::Lock.new
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def rebind(&block)
    with_barrier do
      @bind = false
      bind(&block)
    end
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.7.0
  def bind(&block)
    with_barrier do
      if @binded
        @value
      else
        @binded = true
        @value = yield(@value)
      end
    end
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def with_barrier(&block)
    @barrier.synchronize(&block)
  end
end
