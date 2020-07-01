# frozen_string_literal: true

require 'smart_core/container'
require 'set'

# @api public
# @since 0.1.0
module SmartCore
  class << self
    # @param containers [Array<SmartCore::Container>]
    # @return [Module]
    #
    # @api public
    # @since 0.1.0
    # rubocop:disable Naming/MethodName
    def Injection(*containers)
      ::SmartCore::Injection::Injector::Modulizer.with_containers(containers)
    end
    # rubocop:enable Naming/MethodName
  end

  # @api public
  # @since 0.1.0
  module Injection
    require_relative 'injection/version'
    require_relative 'injection/injector'
    require_relative 'injection/locator'
    require_relative 'injection/dsl'

    class << self
      # @param base_klass [Class, Module]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def included(base_klass)
        ::SmartCore::Injection::Injector::Modulizer.inject_to(base_klass)
      end
    end
  end
end
