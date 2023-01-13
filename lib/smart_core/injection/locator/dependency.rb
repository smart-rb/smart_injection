# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
class SmartCore::Injection::Locator::Dependency
  # @option memoize [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def initialize(memoize:)
    @binded = false
    @value = nil
    @memoize = memoize
    @barrier = SmartCore::Engine::Lock.new
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def rebind(&block)
    with_barrier do
      @binded = false
      bind(&block)
    end
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  # @version 0.3.0
  def bind(&block)
    with_barrier do
      # NOTE:
      #   Temporary disabled old variant of dependency resolving
      #   cuz we need to reivew the canonical way of dependency resolving
      #   and rework the resolving at all on runtime level (under `memoize: true` option).
      #   Old code variant:
      #
      #   if @binded
      #     @value
      #   else
      #     @binded = true
      #     @value = yield
      #   end

      if @memoize
        if @binded
          @value
        else
          @binded = true
          @value = yield
        end
      else
        yield
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
