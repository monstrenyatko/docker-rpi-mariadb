MariaDB Docker image for Raspberry Pi
=====================================

[![Build Status](https://travis-ci.org/monstrenyatko/docker-rpi-mariadb.svg?branch=master)](https://travis-ci.org/monstrenyatko/docker-rpi-mariadb)


About
=====

[MariaDB](https://mariadb.org) relational database in the `Docker` container.

Upstream Links
--------------
* Docker Registry @[monstrenyatko/rpi-mariadb](https://hub.docker.com/r/monstrenyatko/rpi-mariadb/)
* GitHub @[monstrenyatko/docker-rpi-mariadb](https://github.com/monstrenyatko/docker-rpi-mariadb)
* Official Docker Registry @[mariadb](https://hub.docker.com/_/mariadb/)


Quick Start
===========

* Pull prebuilt `Docker` image:

	```sh
		docker pull monstrenyatko/rpi-mariadb
	```
* Start prebuilt image:

	```sh
		docker-compose up -d
	```
* Retrieve `root` password:

	`root` password is randomly generated on first start (See `docker-compose.yml`).
	Check logs to find the string prefixed with `GENERATED ROOT PASSWORD`:
	```sh
		docker-compose logs | grep "GENERATED ROOT PASSWORD"
	```
* Verify default configuration:

	```sh
		docker exec -it mariadb mysql -h localhost -u root -p
		<enter root password>
	```
* Follow the instructions printed in logs on first boot to change `root` password:
	```sh
		docker-compose logs
	```
* Stop/Restart:

	```sh
		docker-compose stop
		docker-compose start
	```
* Configuration:

	- Add additional configuration file:
	```yaml
		mariadb:
		  ...
		  volumes:
		    - ./custom.cnf:/etc/mysql/conf.d/custom.cnf:ro
	```
	- Override the main configuration file:
	```yaml
		mariadb:
		  ...
		  volumes:
		    - ./my_custom.cnf:/etc/mysql/my.cnf:ro
	```

	See [official Docker image](https://hub.docker.com/_/mariadb/) about all available options.

Container is already configured for automatic restart (See `docker-compose.yml`).

Build own image
===============

```sh
		cd <path to sources>
		./build.sh <tag name>
```
