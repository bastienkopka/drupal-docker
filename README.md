# Install a drupal project with Docker

## Include
_All services available in configuration._

* Nginx 1.19
* Php 7.4 fpm
* MySQL/MariaDB 10.5.8

## Requirements
To use this project template :
* [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)
* [Docker compose](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04)


### Install a project
```bash
make install
```

### Destroy a project
```bash
make nuke
```

### Access to php container
```bash
make shell
```