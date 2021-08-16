#!/bin/sh

curl_args="--fail --insecure --basic --user admin:admin"
curl_host="https://127.0.0.1:9200"

if [ -f insert.local ]; then
	. ./insert.local
fi

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
