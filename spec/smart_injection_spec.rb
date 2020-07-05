# frozen_string_literal: true

RSpec.describe 'Smoke test' do
  it 'has a version number' do
    expect(SmartCore::Injection::VERSION).not_to be nil
  end

  specify do
    AppContainer = SmartCore::Container.define do
      namespace(:database) do
        register(:logger) { 'app_logger' }
      end
    end

    AnotherContainer = SmartCore::Container.define do
      namespace(:clients) do
        register(:kickbox) { 'kickbox' }
      end

      namespace(:database) do
        register(:logger) { 'another_logger' }
      end
    end

    ThirdContainer = SmartCore::Container.define do
      namespace(:loggers) do
        register(:global) { 'global_logger' }
      end
    end

    class Cerberus
      include SmartCore::Injection(AppContainer) # указываем базовый контейнер для автоезолвинга

      register_container(AnotherContainer) # регистрируем дополнительный контейнер для авторезолвинга

      import({ logger: 'database.logger' }, memoize: true, access: :public)
      import_static({ kickbox: 'clients.kickbox' }, bind: :static) # bind: :dynamic (резолв в рантайме)
      import({ global_logger: 'loggers.global' }, from: ThirdContainer) # ассоциируем импорт с незареганным контейнером

      def call
        logger.info(kickbox.client)
      end

    end

    Cerberus.linked_containers # array of associated containers
    app = Cerberus.new

    expect(app.logger).to eq('another_logger')
    expect(app.global_logger).to eq('global_logger')
    expect(Cerberus.kickbox).to eq('kickbox')
  end
end
