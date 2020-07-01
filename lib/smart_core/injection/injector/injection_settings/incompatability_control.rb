# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Injection::Injector::InjectionSettings::IncompatabilityControl
  class << self
    # @param imports [Hash<String|Symbol,String>]
    # @param memoize [Boolean]
    # @param access [Symbol]
    # @param bind [Symbol]
    # @param from [NilClass, SmartCore::Container]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_incompatabilities!(imports, memoize, access, bind, from)
      prevent_imports_incompatabilites!(imports)
      prevent_memoize_incompatabilites(memoize)
      prevent_access_incompatabilites(access)
      prevent_bind_incompatabilites(bind)
      prevent_from_incompatabilites(from)
    end

    private

    # @param imports [Hash<String|Symbol,String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_imports_incompatabilites!(imports)
      unless imports.is_a?(::Hash)
        raise(SmartCore::Injection::ArgumentError)
      end

      unless imports.keys.all? { |key| key.is_a?(String) || key.is_a?(Symbol) }
        raise(SmartCore::Injection::ArgumentError)
      end

      unless imports.values.all? { |value| value.is_a?(String) }
        raise(SmartCore::Injection::ArgumentError)
      end
    end

    # @param memoize [Boolean]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_memoize_incompatabilites(memoize)
      unless memoize.is_a?(::TrueClass) || memoize.is_a?(::FalseClass)
        raise(SmartCore::Injection::ArgumentError)
      end
    end

    # @param access [Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_access_incompatabilites(access)
      unless SmartCore::Injection::Injector::InjectionSettings::ACCESS_MARKS.include?(access)
        raise(SmartCore::Injection::ArgumentError)
      end
    end

    # @param bind [Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_bind_incompatabilites(bind)
      unless SmartCore::Injection::Injector::InjectionSettings::BINDING_STRATEGIES.include?(bind)
        raise(SmartCore::Injection::ArgumentError)
      end
    end

    # @param from [NilClass, SmartCore::Container]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_from_incompatabilites(from)
      unless from.is_a?(NilClass) || from.is_a?(SmartCore::Container)
        raise(SmartCore::Injection::ArgumentError)
      end
    end
  end
end
