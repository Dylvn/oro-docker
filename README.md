# Oro Docker

A [Docker](https://www.docker.com/)-based installer and runtime for the [Oro](https://www.oroinc.com/) applications,
with [FrankenPHP](https://frankenphp.dev) and [Caddy](https://caddyserver.com/) inside!

## Getting Started

### Linux

1. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+)
2. Run `docker compose build -f compose.yaml -f compose.php.yaml build --pull --no-cache` to build fresh images
3. Run `docker compose up -f compose.yaml -f compose.php.yaml up --pull always -d --wait` to start the project
4. Run `docker compose exec php php bin/console oro:install --application-url='https://localhost'` to install the oro application.
5. Open `https://localhost` in your favorite web browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334)
6. Run `docker compose down --remove-orphans` to stop the Docker containers.

### Macos

> Due to performance considerations on macOS, it is recommended to use Symfony Server for local development.  
> But if you still want to use Docker, you can follow the instructions below.

1. Follow the [Symfony Server installation](https://doc.oroinc.com/backend/setup/dev-environment/docker-and-symfony/mac/) instructions.
2. Follow the [Symfony Server Local domain names](https://symfony.com/doc/current/setup/symfony_server.html#local-domain-names).
3. Run `composer create-project oro/commerce-crm-application tmp 5.1.0 --no-progress --no-interaction --no-install`
4. Run `cd tmp`
5. Run `rm -Rf docker-compose.yaml`
6. Run `composer install --no-progress --no-interaction`
7. Run `cp -Rp . ..`
8. Run `cd - && rm -Rf tmp`
9. Run `docker compose up --pull always -d --wait` to start the dependencies
10. Run `symfony console oro:install` to install the oro application.
11. Run `symfony proxy:start` to start the symfony proxy.
12. Run `symfony server:start -d` to start the symfony server.
13. Open your configured domain in your favorite web browser.

## Features

* development and CI ready
* Just 1 service by default
* Blazing-fast performance thanks to [the worker mode of FrankenPHP](https://github.com/dunglas/frankenphp/blob/main/docs/worker.md) (automatically enabled in prod mode)
* [Installation of extra Docker Compose services](docs/extra-services.md) with Symfony Flex
* Automatic HTTPS
* HTTP/3 and [Early Hints](https://symfony.com/blog/new-in-symfony-6-3-early-hints) support
* Real-time messaging thanks to a built-in [Mercure hub](https://symfony.com/doc/current/mercure.html)
* [Vulcain](https://vulcain.rocks) support
* Native [XDebug](docs/xdebug.md) integration
* Super-readable configuration

**Enjoy!**

## Docs

1. [Build options](docs/build.md)
2. [Using Symfony Docker with an existing project](docs/existing-project.md)
3. [Support for extra services](docs/extra-services.md)
4. [Deploying in production](docs/production.md)
5. [Debugging with Xdebug](docs/xdebug.md)
6. [TLS Certificates](docs/tls.md)
7. [Using a Makefile](docs/makefile.md)
8. [Troubleshooting](docs/troubleshooting.md)
9. [Updating the template](docs/updating.md)

## License

Symfony Docker is available under the MIT License.

## Credits

Created by [Kévin Dunglas](https://dunglas.dev), co-maintained by [Maxime Helias](https://twitter.com/maxhelias) and sponsored by [Les-Tilleuls.coop](https://les-tilleuls.coop).
