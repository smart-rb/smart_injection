# SmartCore::Injection &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a> &middot; [![Gem Version](https://badge.fury.io/rb/smart_injection.svg)](https://badge.fury.io/rb/smart_injection)

Dependency injection principles and idioms realized in scope of Ruby. Support for method-injeciton strategy, container-based dependency resolving, static and dynamic bindings and etc.

---

<p>
  <a href="https://github.com/Cado-Labs">
    <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_supporting.svg" alt="Supported by Cado Labs" />
  </a>
</p>

---

## Major Features

- `method-injection` strategy
- `soon:` constructor injection strategy;
- `soon:` property injection strategy;
- realized as a mixin;
- instance-method dependency injection;
- class-method dependency injection;
- multiple IoC-container registration;
- static and dynamic bindings;
- support for memoization with run-time dependency-switchable re-memoization;
- an ability to import dependencies from the list of IoC-containers
- an ability to import from the pre-configured default IoC-container(s);
- an ability to import from any manually passed IoC-container;
- privacy control of injected dependency (public/private/protected);

---

## Usage

- [Installation](#installation)
- [Synopsis](#synopsis)
- [Roadmap](#roadmap)
- [Build](#build)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)

---

## Installation

```ruby
gem 'smart_injection'
```

```shell
bundle install
# --- or ---
gem install smart_injection
```

```ruby
require 'smart_core/injection'
```

---

## Synopsis

Create some containers:

```ruby
AppContainer = SmartCore::Container.define do
  namespace(:data_storage) do
    register(:main) { Sequel::Model.db }
    register(:cache) { Redis.new }
  end
end

ServiceContainer = SmartCore::Container.define do
  namespace(:rands) do
    register(:alphanum) { -> { SecureRandom.alphanumeric } }
    register(:hex) { -> { SecureRandom.hex } }
  end
end

GlobalContainer = SmartCore::Container.define do
  namespace(:phone_clients) do
    register(:nexmo) { Nexmo.new }
    register(:twilio) { Twilio.new }
  end
end
```

And work with dependency injection:

```ruby
class MiniService
  include SmartCore::Injection

  register_container(AppContainer)
  register_container(ServiceContainer)

  # --- or ---
  include SmartCore::Injection(AppContainer, ServiceContainer)

  # --- or ---
  include SmartCore::Injection
  register_container(AppContainer, ServiceContainer)

  # import dependencies to an instance
  import({ db: 'data_storage.main' }, bind: :dynamic, access: :private)
  import({ rnd: 'rands.alphanum' }, bind: :static, memoize: true)

  # import dependencies to a class
  import_static({ cache: 'data_storage.cache', hexer: 'rands.hex' }, bind: :static)

  # import from a non-registered container
  import({ phone_client: 'phone_clients.nexmo' }, from: GlobalContainer)

  def call
    db # => returns data_storage.main
    rnd # => returns rands.alphanum
    self.class.cache # => returns data_storage.cache
    self.class.hexer # => returns rands.hexer
    phone_client # => returns phone_clients.nexmo
  end
end
```

---

## Roadmap

- **[0.3.0]** - support for default injection configuration which should be specified in `SmartCore::Injection` module inclusion (in addition to default containers)
- **[0.x.0]** - more docs, more examples, more tips-and-tricks :)
- **[0.x.0]** - migrate to GithubActions;
- **[0.x.0]** - type signatures (rbs);

---

## Build

- run tests:

```shell
bundle exce rake rspec
```

- run code style checking:

```shell
bundle exec rake rubocop
```

- run code style checking with auto-correction:

```shell
bundle exec rake rubocop -A
```

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_injection )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_logo.png" alt="Supported by Cado Labs" />
</a>

## Authors

[Rustam Ibragimov](https://github.com/0exp)
