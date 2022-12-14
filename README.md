# Shim Docker secrets into your Ruby ENV

`berkeley_library-docker` autoloads the contents of your secrets files into environment variables having the same name as the source file. If using Rails, it's autoloaded via a Railtie, so there's no need to do anything besides require the gem. Otherwise, you can call it manually via:

```ruby
require 'berkeley_library/docker'
BerkeleyLibrary::Docker::Secret.load_secrets!
```

---

> **Note on (Rails) load order:** This gem loads the environment using Rails' `before_configuration` hook, a la the [dotenv](https://github.com/bkeepers/dotenv#note-on-load-order) gem. Manually call `BerkeleyLibrary::Docker::Secret.load_secrets!` if you need to load secrets earlier.

---

Secrets are loaded from `/run/secrets` by default. You can override this by passing another path (or glob pattern) to the `load_secrets!` method, or by setting the `UCBLIB_SECRETS_PATTERN` environment variable. For example:

```ruby
# Load any file under /tmp/secrets
BerkeleyLibrary::Docker::Secret.load_secrets! '/tmp/secrets/**/*'

# Load only a specific file
ENV['UCBLIB_SECRETS_PATTERN'] = '/run/secrets/DB_PASSWORD'
BerkeleyLibrary::Docker::Secret.load_secrets!
```

## Testing

```ruby
bundle install
rspec
```
