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
      prevent_imports_incompatabilites(imports)
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
    def prevent_imports_incompatabilites(imports)
    end

    # @param memoize [Boolean]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_memoize_incompatabilites(memoize)
    end

    # @param access [Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_access_incompatabilites(access)
    end

    # @param bind [Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_bind_incompatabilites(bind)

    end

    # @param from [NilClass, SmartCore::Container]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_from_incompatabilites(from)
    end
  end
end
