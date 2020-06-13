# frozen_string_literal: true

RSpec.describe 'Smoke test' do
  it 'has a version number' do
    expect(SmartCore::Injection::VERSION).not_to be nil
  end
end
