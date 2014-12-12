# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    hyperion/grafana

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV GRAFANA_VERSION 1.8.1

RUN apt-get update -q && \
    apt-get install -y nginx-light supervisor && \
    apt-get clean

RUN mkdir -p /src/grafana && cd /src/grafana && \
    wget http://grafanarel.s3.amazonaws.com/grafana-$GRAFANA_VERSION.tar.gz && \
    tar xzvf grafana-$GRAFANA_VERSION.tar.gz --strip-components=1 && \
    rm grafana-$GRAFANA_VERSION.tar.gz

ADD ./grafana_config.js /src/grafana/config.js
ADD ./hyperion-lite.json /src/grafana/app/dashboards/default.json

# Nginx
ADD ./nginx.conf /etc/nginx/nginx.conf

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
