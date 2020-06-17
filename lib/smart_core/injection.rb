# frozen_string_literal: true

require 'smart_core/container'

# @api public
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  module Injection
    require_relative 'injection/version'
  end

  class << self
    # @param container [SmartCore::Container]
    # @return [Module]
    #
    # @api public
    # @since 0.1.0
    # rubocop:disable Naming/MethodName
    def Injection(container)
    end
    # rubocop:enable Naming/MethodName
  end
end
