# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Injection::Injector::Strategies::MethodInjection
  class << self
    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inject_instance_method(injection_settings)
      inject_dependency(injection_settings, injection_settings.instance_level_injectable)
    end

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inject_class_method(injection_settings)
      inject_dependency(injection_settings, injection_settings.class_level_injectable)
    end

    private

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @param injectable [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inject_dependency(injection_settings, injectable)
      injection_settings.each_import do |import_key, import_path|
        locator = build_locator(injection_settings, import_key, import_path)
        process_injection_bindings(injection_settings, locator)
        injection = build_injection(injection_settings, import_key, locator)
        inject_injection(injection_settings, injection, injectable)
      end
    end

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @param import_key [String, Symbol]
    # @param import_path [String]
    # @return [SmartCore::Injection::Locator]
    #
    # @api private
    # @since 0.1.0
    def build_locator(injection_settings, import_key, import_path)
      SmartCore::Injection::Locator::Factory.create(injection_settings, import_key, import_path)
    end

    # @param locator [SmartCore::Injection::Locator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def process_injection_bindings(injection_settings, locator)
      locator.bind! if injection_settings.bind_static?
    end

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @param import_key [String, Symbol]
    # @param locator [SmartCore::Injection::Locator]
    # @return [Module]
    #
    # @api private
    # @since 0.1.0
    def build_injection(injection_settings, import_key, locator)
      Module.new do
        define_method(import_key) { locator.resolve_dependency }

        case injection_settings.access
        when :public then public(import_key)
        when :private then private(import_key)
        when :protected then protected(import_key)
        end
      end
    end

    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @param injection [Module]
    # @param injectable [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inject_injection(injection_settings, injection, injectable)
      injectable.include(injection)
    end
  end
end
