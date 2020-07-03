# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Injector::InjectionParameters
  require_relative 'injection_parameters/incompatability_control'

  # @return [Hash<String|Symbol,String>]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_IMPORTS = {}.freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_ACCESS = :public

  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.1.0
  ACCESS_MARKS = %i[public protected private].freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_BINDING_STRATEGY = :dynamic

  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.1.0
  BINDING_STRATEGIES = %i[static dynamic].freeze

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_MEMOIZE = false

  # @return [NilClass]
  #
  # @api private
  # @since 0.1.0
  EMPTY_CONTAINER_DESTINATION = nil

  # @return [Hash<String|Symbol,String>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :imports

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :access

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :bind

  # @return [NilClass, <SmartCore::Container>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :from

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  attr_reader :memoize

  # @return [SmartCore::Injection::Injector::ContainerSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :container_set

  # @return [Class, Module]
  #
  # @api private
  # @since 0.1.0
  attr_reader :injectable

  # @param injectable [Class, Module]
  # @param container_set [SmartCore::Injection::Injector::ContainerSet]
  # @param import [Hash<String|Symbol,String>]
  # @option memoize [Boolean]
  # @option access [Symbol]
  # @option bind [Symbol]
  # @option from [NilClass, SmartCore::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(
    injectable,
    container_set,
    imports,
    memoize: DEFAULT_MEMOIZE,
    access: DEFAULT_ACCESS,
    bind: DEFAULT_BINDING_STRATEGY,
    from: EMPTY_CONTAINER_DESTINATION
  )
    IncompatabilityControl.prevent_incompatabilities!(
      injectable,
      imports,
      memoize,
      access,
      bind,
      from
    )

    @injectable = injectable
    @container_set = container_set
    @imports = imports
    @memoize = memoize
    @access = access
    @bind = bind
    @from = from
  end

  # @return [Class, Module]
  #
  # @api private
  # @since 0.1.0
  def instance_level_injectable
    injectable
  end

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  def class_level_injectable
    class << injectable; self; end
  end

  # @param block [Block]
  # @yield [import_key, import_path]
  # @yieldparam import_key [String, Symbol]
  # @yieldparam import_path [String]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_import(&block)
    block_given? ? imports.each_pair(&block) : imports.each_pair
  end
end
