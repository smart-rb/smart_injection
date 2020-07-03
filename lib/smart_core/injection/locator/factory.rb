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
    def create(injection_settings, import_key, import_path); end
  end
end
