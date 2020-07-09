# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector::ContainerSet::AddingListener
  # @param listener [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(listener)
    @listener = listener
  end

  # @param cotnainer [SmartCore::Container]
  #
  # @api private
  # @since 0.1.0
  def notify(container)
    listener.call(container)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :listener
end
