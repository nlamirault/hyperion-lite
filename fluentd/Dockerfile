# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    hyperion/influxdb

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get -q update && \
    apt-get install -y -q curl libcurl4-openssl-dev make sudo ruby-dev
RUN curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

ENV LD_PRELOAD /usr/lib/fluent/jemalloc/lib/libjemalloc.so
RUN ulimit -n 65536

# Install plugins
RUN /usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-elasticsearch
RUN /usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-record-reformer
RUN /usr/lib/fluent/ruby/bin/fluent-gem install -V fluentd-ui

EXPOSE 24224
EXPOSE 9292

ADD run.sh /usr/local/bin/run

CMD ["/usr/local/bin/run"]
