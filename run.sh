#!/bin/sh

# Debug output
set -v

# Exit on error
set -e

if [ "$1" = 'mariadb-app' ]; then
	shift;
	echo Parameters: "\"$@\""
	chmod +rX -R /etc/mysql
	mkdir -p /run/mysqld
	chown -R mysql /run/mysqld
	exec /mariadb-docker-entrypoint.sh mysqld "$@"
fi

exec "$@"
