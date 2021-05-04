#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)

echo "Configure Health Adviser: "

curl \
     --write-out "%{http_code}" \
     --silent \
     --output /dev/null \
     --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
     --data-binary "script=$(cat groovy/configure_health_adviser.groovy)" \
     --user $USERNAME:$JENKINS_TOKEN \
     ${URL}/cjoc/scriptText

echo ""
