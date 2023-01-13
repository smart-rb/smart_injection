# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
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
  # @option memoize_dependency [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def initialize(import_path, container_proxy, memoize_dependency:)
    @import_path = import_path
    @container_proxy = container_proxy
    @memoize_dependency = memoize_dependency
    @dependency = SmartCore::Injection::Locator::Dependency.new(memoize: memoize_dependency)
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
    dependency.rebind { container_proxy.resolve_dependency(import_path) }
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

  # NOTE: non-usable ivar, added only for commfort debaggung
  # NOTE: will be reworked in next version
  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  attr_reader :memoize_dependency
end
