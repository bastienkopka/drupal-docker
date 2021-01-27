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
	@sed -i "s/LOCAL_UID=1000/LOCAL_UID=$(UID)/g" ./.env;
	@sed -i "s/LOCAL_GID=1000/LOCAL_GID=$(GID)/g" ./.env;
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

composer-install:
	@docker exec -u $(APP_USER) -it $(PHP_CONTAINER) composer install --prefer-dist

composer-update:
	@docker exec -u $(APP_USER) -it $(PHP_CONTAINER) composer update

fix-permissions:
	@docker exec -it $(PHP_CONTAINER) /bin/sh -c 'cd /var/www/app && chown -R $(APP_USER):$(APP_USER) .'


### Global commands
install: build composer-install fix-permissions