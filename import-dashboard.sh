#!/bin/sh

opensearch_dashboards_protocol="http"
opensearch_dashboards_host="localhost"
opensearch_dashboards_port=5601
opensearch_dashboards_api_curl_args="--fail --basic --user admin:admin"

if [ -f local-config.sh ]; then
	. ./local-config.sh
fi

curl_host="${opensearch_dashboards_protocol}://${opensearch_dashboards_host}:${opensearch_dashboards_port}"
curl_args="${opensearch_dashboards_api_curl_args}"

set -ex

for file; do
  curl ${curl_args} -XPOST -H 'osd-xsrf: true' -H 'Content-Type: application/json' "${curl_host}/api/opensearch-dashboards/dashboards/import" -d "@${file}"
done
