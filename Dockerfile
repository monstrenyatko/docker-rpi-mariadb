FROM hypriot/rpi-alpine:3.6

MAINTAINER Oleg Kovalenko <monstrenyatko@gmail.com>

ENV LANG en_US.utf8

RUN apk update && \
    apk add --no-cache mariadb mariadb-client tzdata pwgen bash su-exec && \
    \
# mimic gosu
    ln -s /sbin/su-exec /usr/bin/gosu && \
    \
    mkdir -p /docker-entrypoint-initdb.d && \
    \
# enable external config directory
    mkdir -p /etc/mysql/conf.d && \
    echo $'\n''!includedir /etc/mysql/conf.d/' >> /etc/mysql/my.cnf && \
# don't reverse lookup hostnames, they are usually another container
    sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf && \
    echo '[mysqld]'$'\n''skip-host-cache'$'\n''skip-name-resolve' > /etc/mysql/conf.d/docker.cnf && \
    \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/cache/apk/*

COPY run.sh /
RUN chmod +x /run.sh

COPY mariadb-docker-entrypoint.sh /
RUN chmod +x /mariadb-docker-entrypoint.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/run.sh"]
CMD ["mariadb-app"]
