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
    @observers = Hash.new { |h, k| h[k] = [] }
    registered_containers.listen_addings { |container| listen_changes(container) }
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
    register_observer(import_path, observer)

    each_container do |container|
      container.observe(import_path) { |path, cntr| process_changement(cntr, path) }
    end
  end

  private

  # @return [Hash<String,Proc>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :observers

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

  # @param import_path [NilClass, String]
  # @param container [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_changement(container, import_path = nil)
    observed_pathes = import_path ? [import_path] : observed_import_pathes

    observed_pathes.each do |observed_path|
      suitable_container = each_container.find { |cntr| cntr.key?(observed_path) }
      break unless suitable_container
      notify_observers(observed_path) if suitable_container == container
    end
  end

  # @param import_path [String]
  # @param observer [SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register_observer(import_path, observer)
    observers[import_path] << observer
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def observed_import_pathes
    observers.keys
  end

  # @param import_pathes [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def notify_observers(*import_pathes)
    import_pathes.each { |import_path| observers.fetch(import_path).each(&:call) }
  end

  # @param block [Block]
  # @yield [container]
  # @yieldparam container [SmartCore::Container]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_container(&block)
    enumerator = Enumerator.new do |yielder|
      if explicitly_passed_container
        yielder.yield(explicitly_passed_container)
      else
        registered_containers.reverse_each(&yielder)
      end
    end

    block_given? ? enumerator.each(&block) : enumerator.each
  end
end
