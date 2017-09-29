#!/bin/bash

# Usage: file_env_opt VAR [DEFAULT]
file_env_opt() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ -z "${!var:-}" ] && [ -z "${!fileVar:-}" ] && [ -z "${def:-}" ]; then
		return 0
	fi
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

# Debug output
set -x

# Exit on error
set -e

if [ -n "$MYSQL_GID" ]; then
	groupmod --gid $MYSQL_GID mysql
	usermod --gid $MYSQL_UID mysql
fi

if [ -n "$MYSQL_UID" ]; then
	usermod --uid $MYSQL_UID mysql
fi

if [ "$1" = 'mariadb-app' ]; then
	shift;
	set +x
	file_env_opt 'MYSQL_ROOT_PASSWORD'
	file_env_opt 'MYSQL_PASSWORD'
	set -x
	chmod +rX -R /etc/mysql
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
	exec /mariadb-docker-entrypoint.sh mysqld "$@"
fi

exec "$@"
