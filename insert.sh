#!/bin/sh

opensearch_protocol="https"
opensearch_host="localhost"
opensearch_port=9200
opensearch_curl_args="--insecure --fail --basic --user admin:admin"

if [ -f local-config.sh ]; then
	. ./local-config.sh
fi

curl_host="${opensearch_protocol}://${opensearch_host}:${opensearch_port}"
curl_args="${opensearch_curl_args}"

curl $curl_args -X DELETE "${curl_host}/covid?pretty"

set -e

curl $curl_args -X PUT -H 'Content-Type: application/json' "${curl_host}/covid?pretty" -d '{
  "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date"
        }
    }
  }
}'

while read line; do
	echo "$line" | curl $curl_args -X POST -H 'Content-Type: application/json' -d @- "${curl_host}/covid/_doc/?pretty"
done
