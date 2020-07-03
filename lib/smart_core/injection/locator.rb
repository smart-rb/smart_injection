# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Injection::Locator
  require_relative 'locator/container_proxy'
  require_relative 'locator/settings'
  require_relative 'locator/factory'

  # @param import_path [String]
  # @param container_proxy [SmartCore::Injection::Locator::ContainerProxy]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(import_path, container_proxy)
    @import_path = import_path
    @container_proxy = container_proxy
    @dependency = SmartCore::Engine::Atom.new
  end

  # инстанцируется настройками инжекта (БЕЗ ИМПОРТОВ)
  # инстанцируется объектом КОНТЕЙНЕР_ПРОКСИ
  # инстанцируется ключем импорта, которым мы достаем через прокси нужную депенденси И уже
  #   в зависимости от настроек мемоизируем ее ИЛИ пытаемся пере-импортирвоать и тд и тп
  # на каждый кей-веэлью в импортах свой отдельный локатор
  # создание локатора идет через Фэктори, который Создаем контейнер-прокси
  #   сам фэктори инстанцируется вместе с инъекшн-сеттингсами, из которых он и создаст нужный контейнер-прокси
end
