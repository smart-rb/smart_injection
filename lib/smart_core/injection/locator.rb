# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Locator
  require_relative 'locator/container_proxy'
  require_relative 'locator/dependency'
  require_relative 'locator/factory'

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :import_path

  # @param import_path [String]
  # @param container_proxy [SmartCore::Injection::Locator::ContainerProxy]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(import_path, container_proxy)
    @import_path = import_path
    @container_proxy = container_proxy
    @dependency = SmartCore::Injection::Locator::Dependency.new
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def resolve_dependency
    dependency.bind { container_proxy.resolve_dependency(import_path) }
  end
  alias_method :bind!, :resolve_dependency

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def rebind_dependency
    dependency.rebind { container_proxy.resolve(import_path) }
  end
  alias_method :rebind!, :rebind_dependency

  private

  # @return [SmartCore::Injection::Locator::Dependency]
  #
  # @api private
  # @since 0.1.0
  attr_reader :dependency

  # @return [SmartCore::Injection::Locator::ContainerProxy]
  #
  # @api private
  # @since 0.1.0
  attr_reader :container_proxy
end
