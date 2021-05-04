#!/usr/bin/env bash

status=000

URL=$1
USERNAME=$2
PASSWORD=$3
CONTROLLER=$( echo $4 | awk '{print tolower($0)}')

while [[ 200 != $status ]]; do
  status=$(
  curl ${URL}/${CONTROLLER}/systemInfo \
    --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
    --user $USERNAME:$PASSWORD \
    --location \
    --silent \
    --output /dev/null \
    --write-out "%{http_code}" \
    --cookie-jar .cookies.txt
  )
  sleep 20
  echo "Status of ${URL}/${CONTROLLER}: ${status}. Cloudbees CI isn't ready yet."
done
echo "Cloudbees CI is now ready."
