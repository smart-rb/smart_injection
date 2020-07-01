# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Injection::Injector::Commands::InjectInstanceMethod
  class << self
    # @param injection_settings [SmartCore::Injection::Injector::InjectionSettings]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(injection_settings)
      # надо бы инжектирование вынести в отдельный объект-комманду,
      # который по спску импортов будет проходит и создавать локаторы,
      # создавая на классе инстанс-метод или класс-метод сооветственно с проброшеным локатором
    end
  end
end
