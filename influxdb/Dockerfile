# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    hyperion/influxdb

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN mkdir -p /src/influxdb && \
    wget http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb && \
    dpkg -i influxdb_latest_amd64.deb

ADD ./config.toml /src/influxdb/config.toml

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8083
EXPOSE 8086
EXPOSE 8090
EXPOSE 8099

VOLUME ["/var/lib/influxdb"]
