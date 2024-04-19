#syntax=docker/dockerfile:1.4

# Versions
FROM dunglas/frankenphp:1-php8.2 AS frankenphp_upstream

# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target

# Base FrankenPHP image
FROM frankenphp_upstream AS frankenphp_base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
	acl \
	file \
	gettext \
	git \
	autoconf \
	g++ \
	make \
	libssl-dev \
    curl \
    gnupg \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y --no-install-recommends nodejs \
	&& rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@9

RUN set -eux; \
	install-php-extensions \
		@composer \
		apcu \
		intl \
		opcache \
		zip \
		ctype \
		curl \
		fileinfo \
		gd \
		json \
		mbstring \
		sodium \
		openssl \
		pgsql \
		pcre \
		simplexml \
		tokenizer \
		xml \
		imap \
		soap \
		bcmath \
		ldap \
    	pcntl \
    	pdo_pgsql \
    	sockets \
	;

RUN set -eux; \
    pecl install mongodb; \
    docker-php-ext-enable mongodb;

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY --link frankenphp/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link --chmod=755 frankenphp/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --link frankenphp/Caddyfile /etc/caddy/Caddyfile

ENTRYPOINT ["docker-entrypoint"]

HEALTHCHECK --start-period=300s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

# Dev FrankenPHP image
FROM frankenphp_base AS frankenphp_dev

ENV APP_ENV=dev XDEBUG_MODE=off ORO_ENV=dev ORO_DEBUG=1
VOLUME /app/var/

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

COPY --link frankenphp/conf.d/app.dev.ini $PHP_INI_DIR/conf.d/

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--watch" ]

# Prod FrankenPHP image
FROM frankenphp_base AS frankenphp_prod

ENV APP_ENV=prod
ENV FRANKENPHP_CONFIG="import worker.Caddyfile"

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --link frankenphp/conf.d/app.prod.ini $PHP_INI_DIR/conf.d/
COPY --link frankenphp/worker.Caddyfile /etc/caddy/worker.Caddyfile

# prevent the reinstallation of vendors at every changes in the source code
COPY --link composer.* symfony.* ./
RUN set -eux; \
	composer install --no-cache --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress

# copy sources
COPY --link . ./
RUN rm -Rf frankenphp/

RUN set -eux; \
	mkdir -p var/cache var/log; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	composer dump-env prod; \
	composer run-script --no-dev post-install-cmd; \
	chmod +x bin/console; sync;
