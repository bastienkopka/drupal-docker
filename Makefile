UID=$$(id -u $$USER)
GID=$$(id -g $$USER)

SUPPORTED_COMMANDS := init build install install-new-project
INSTALL_ARGS := dev
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))

ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  INSTALL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

  ifeq (, $(INSTALL_ARGS))
    INSTALL_ARGS := dev
  endif

  $(eval $(INSTALL_ARGS):;@:)
endif

ifneq ("$(wildcard ./.env)","")
    include ./.env
else
    include ./env.$(INSTALL_ARGS)
endif

PHP_CONTAINER=php_$(PROJECT_NAME)


### Setup commands
init:
	@cp ./docker-compose.$(INSTALL_ARGS).yml ./docker-compose.yml;
	@cp ./env.$(INSTALL_ARGS) ./.env;
	@mkdir -p ./www;

build: init
	@docker-compose up -d --build --remove-orphans;
	./scripts/update_hosts.sh $(PROJECT_NAME);

up:
	@docker-compose up -d;
	./scripts/update_hosts.sh $(PROJECT_NAME);

stop:
	@docker-compose stop;
	@docker-compose down;

nuke: stop
	@sudo rm -rf ./docker-images/mysql;
	@sudo rm -rf ./www;


### Docker commands
shell:
	@docker exec -u $(APP_USER) -it $(PHP_CONTAINER) /bin/sh

create-project:
	@docker exec -it $(PHP_CONTAINER) composer create-project --no-install drupal/recommended-project:9.1 .

composer-install:
	@docker exec -u $(APP_USER) -it $(PHP_CONTAINER) composer install --prefer-dist

composer-update:
	@docker exec -u $(APP_USER) -it $(PHP_CONTAINER) composer update

set-environment:
	@sudo cp ./env.$(INSTALL_ARGS) ./www/.env;

fix-permissions:
	@docker exec -it $(PHP_CONTAINER) /bin/sh -c 'cd /var/www/app && chown -R $(APP_USER):www-data .'


### Global commands
install-new-project: build create-project fix-permissions set-environment
install: build composer-install set-environment fix-permissions