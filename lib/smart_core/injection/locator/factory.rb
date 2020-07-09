# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Injection::Locator::Factory
  class << self
    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @return [SmartCore::Injection::Locator]
    #
    # @api private
    # @since 0.1.0
    def create(injection_settings, import_key, import_path)
      container_proxy = create_container_proxy(injection_settings)
      create_locator(import_path, container_proxy).tap do |locator|
        control_injection_memoization(injection_settings, container_proxy, locator, import_path)
      end
    end

    private

    # @return [SmartCore::Injection::Locator::ContainerProxy]
    #
    # @api private
    # @since 0.1.0
    def create_container_proxy(injection_settings)
      SmartCore::Injection::Locator::ContainerProxy.new(
        injection_settings.container_set,
        injection_settings.from
      )
    end

    # @param import_path [String]
    # @param container_proxy [SmartCore::Injection::Locator::ContainerProxy]
    # @return [SmartCore::Injection::Locator]
    #
    # @api private
    # @since 0.1.0
    def create_locator(import_path, container_proxy)
      SmartCore::Injection::Locator.new(import_path, container_proxy)
    end

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @param locator [SmartCore::Injection::Locator]
    # @param import_path [String]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def control_injection_memoization(injection_settings, container_proxy, locator, import_path)
      container_proxy.observe(import_path) do
        locator.rebind!
      end unless injection_settings.memoize
    end
  end
end
