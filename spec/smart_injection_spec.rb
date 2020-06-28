# frozen_string_literal: true

RSpec.describe 'Smoke test' do
  it 'has a version number' do
    expect(SmartCore::Injection::VERSION).not_to be nil
  end

  specify do
    AppContainer = SmartCore::Container.define do
      namespace(:database) do
        register(:logger) { Logger.new }
      end
    end

    AnotherContainer = SmartCore::Container.define {}
    ThirdContainer = SmartCore::Container.define {}

    class Cerberus
      include SmartCore::Injection(AppContainer) # указываем базовый контейнер для автоезолвинга

      register_container(AnotherContainer) # регистрируем дополнительный контейнер для авторезолвинга

      import({ logger: 'database.logger' }, memoize: true, access: :public)
      import_static({ kickbox: 'clients.kickbox' }, bind: :static) # bind: :dynamic (резолв в рантайме)
      import(ThirdContainer, { global_logger: 'loggers.global' }) # ассоциируем импорт с незареганным контейнером

      def call
        logger.info(kickbox.client)
      end
    end

    Cerberus.linked_containers # array of associated containers
  end
end
