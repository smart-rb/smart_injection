# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Locator::ContainerProxy
  # @param registered_containers [SmartCore::Injection::Injector::ContainerSet]
  # @param explicitly_passed_container [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(registered_containers, explicitly_passed_container)
    @registered_containers = registered_containers
    @explicitly_passed_container = explicitly_passed_container
  end

  # @param dependency_path [String]
  # @return [Any]
  #
  # @raise [SmartCore::Injection::NoRegisteredContainersError]
  # @raise [SmartCore::Container::ResolvingError]
  #
  # @api private
  # @since 0.1.0
  def resolve_dependency(dependency_path)
    resolving_error = nil

    each_container do |container|
      begin # rubocop:disable Style/RedundantBegin
        return container.resolve(dependency_path)
      rescue SmartCore::Container::ResolvingError => error
        resolving_error = error
      end
    end

    unless resolving_error
      raise(SmartCore::Injection::NoRegisteredContainersError, <<~ERROR_MESSAGE)
        You haven't registered any containers for import.
      ERROR_MESSAGE
    else
      raise(resolving_error)
    end
  end

  # @param import_path [String]
  # @param observer [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def observe(import_path, &observer)
    # TODO: implement
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
  attr_reader :explicitly_passed_container

  # @param block [Block]
  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def each_container(&block)
    yield(explicitly_passed_container) if explicitly_passed_container
    registered_containers.reverse_each(&block)
  end
end
