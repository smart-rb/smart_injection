# SmartCore::Injection &middot; [![Gem Version](https://badge.fury.io/rb/smart_injection.svg)](https://badge.fury.io/rb/smart_injection) [![Build Status](https://travis-ci.org/smart-rb/smart_injection.svg?branch=master)](https://travis-ci.org/smart-rb/smart_injection)

Dependency injection principles and idioms realized in scope of Ruby.

---

## Major Features

- method-injection strategy (implicit constructor-injection - in the future);
- realized as a mixin;
- instance-level dependency injection (in scope of Ruby classes);
- class-level dependency injection (in scope of Ruby classes);
- multiple IoC-container registration;
- an ability to import dependencies from the list of IoC-containers
- an ability to import from the pre-configured default IoC-container(s);
- an ability to import from any manually passed IoC-container;
- support for memoization with run-time dependency-switchable re-memoization;
- static and dynamic dependency binding;
- privacy control of injected dependency (public/private/protected);

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

## Contributing

- Fork it ( https://github.com/smart-rb/smart_injection )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
