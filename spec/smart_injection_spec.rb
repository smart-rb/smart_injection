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

    class Cerberus
      include SmartCore::Injection(AppContainer.new)
    end
  end
end
