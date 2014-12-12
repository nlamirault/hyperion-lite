#!/bin/bash

ES_HOST=${ES_PORT_9200_TCP_ADDR:-\"+window.location.hostname+\"}
ES_PORT=${ES_PORT_9200_TCP_PORT:-9200}
ES_SCHEME=${ES_SCHEME:-http}

cat << EOF > /etc/td-agent/td-agent.conf
<source>
  type http
  port 8888
</source>

<match aftership.*>
  type elasticsearch
  host $ES_HOST
  port $ES_PORT
  index_name via_fluentd
  type_name via_fluentd
  logstash_format true
  utc_index true
  include_tag_key false
</match>

EOF

fluentd-ui start
