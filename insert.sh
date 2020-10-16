#!/bin/sh
set -e

curl -X DELETE 'http://127.0.0.1:9200/covid?pretty'
curl -X PUT -H 'Content-Type: application/json' 'http://127.0.0.1:9200/covid?pretty' -d '{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      }
    }
  }
}'

while read line; do
	echo "$line" | curl -X POST -H 'Content-Type: application/json' -d @- 'http://127.0.0.1:9200/covid/_doc/?pretty'
done
