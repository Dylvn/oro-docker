#!/bin/sh
set -e

if [ "$1" = 'frankenphp' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project oro/commerce-crm-application tmp 5.1.4 --no-progress --no-interaction --no-install

		cd tmp
		rm -Rf docker-compose.yml
		cp -Rp . ..
		cd -
		rm -Rf tmp/

		composer require "php:>=$PHP_VERSION" runtime/frankenphp-symfony
		composer config --json extra.symfony.docker 'true'
	fi

	if [ -z "$(ls -A 'vendor/' 2>/dev/null)" ]; then
		composer install --prefer-dist --no-progress --no-interaction
	fi

	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
fi

exec docker-php-entrypoint "$@"
