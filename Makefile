# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up start down logs sh composer vendor sf cc test

## ââ ðµ ð³ The Symfony Docker Makefile ð³ ðµ ââââââââââââââââââââââââââââââââââ
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## ââ Docker ð³ ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

build-php: ## Builds the PHP Docker image
	@$(DOCKER_COMP) -f compose.yaml -f compose.php.yaml build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

up-php: ## Start the PHP container in detached mode (no logs)
	@$(DOCKER_COMP) -f compose.yaml -f compose.php.yaml up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the FrankenPHP container
	@$(PHP_CONT) sh

test: ## Start tests with phpunit, pass the parameter "c=" to add options to phpunit, example: make test c="--group e2e --stop-on-failure"
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -e APP_ENV=test php bin/phpunit $(c)


## ââ Composer ð§ ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## ââ Symfony ðµ âââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf
