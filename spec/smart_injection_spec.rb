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
        register(:vonage) { 'vonage' }
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

      import({ logger: 'database.logger', from: 'clients.vonage' }, memoize: true, access: :public)
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
    expect(app.from).to eq('vonage')
    expect(Cerberus.kickbox).to eq('kickbox')

    ChimeraContainer = SmartCore::Container.define do
      namespace(:heads) do
        register(:snake) { 'snake_head' }
      end
    end

    # inheritance from injection-ready class
    class Chimera < Cerberus
      register_container(ChimeraContainer)

      import({ main_head: 'heads.snake' })

      def call
        main_head
      end
    end

    expect(Chimera.new.call).to eq('snake_head')
    expect(Chimera.kickbox).to eq('kickbox') # from Cerberus.kickbox

    # inheritance from inherited entity
    class Hydra < Chimera
      import({ db_logger: 'database.logger', kickbox: 'clients.kickbox', head: 'heads.snake' }, bind: :static, access: :private)
    end

    hydra = Hydra.new

    expect { hydra.db_logger }.to raise_error(::NoMethodError)
    expect(hydra.send(:db_logger)).to eq('another_logger')

    expect { hydra.kickbox }.to raise_error(::NoMethodError)
    expect(hydra.send(:kickbox)).to eq('kickbox')

    expect { hydra.head }.to raise_error(::NoMethodError)
    expect(hydra.send(:head)).to eq('snake_head')

    expect(hydra.main_head).to eq('snake_head') # from Chimera#main_head
    expect(hydra.from).to eq('vonage') # from Cerberus#from

    expect(Hydra.kickbox).to eq('kickbox') # from Cerberus.kickbox

    # check linked containers
    expect(Hydra.linked_containers).to contain_exactly(
      AppContainer, AnotherContainer, ChimeraContainer
    )
    expect(Chimera.linked_containers).to contain_exactly(
      AppContainer, AnotherContainer, ChimeraContainer
    )
    expect(Cerberus.linked_containers).to contain_exactly(
      AppContainer, AnotherContainer
    )
  end
end
