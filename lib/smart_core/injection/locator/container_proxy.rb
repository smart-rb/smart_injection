# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Locator::ContainerProxy
  # @param registered_containers [SmartCore::Injection::Injector::ContainerSet]
  # @param explicitly_defined_container [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(registered_containers, explicitly_defined_container)
    @registered_containers = registered_containers
    @explicitly_defined_container = explicitly_defined_container
  end

  private

  # @return [SmartCore::Injection::Injector::ContainerSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :registered_containers

  # @return [NilClass, SmartCore::Container]
  #
  # @api private
  # @since 0.1.0
  attr_reader :explicitly_defined_container
end
