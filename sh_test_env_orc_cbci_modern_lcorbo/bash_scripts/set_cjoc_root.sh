#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)

echo "Setting Jenkins Root on CJOC: "
curl  \
     --write-out "%{http_code}" \
     --silent \
     --output /dev/null \
     --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
     --data-binary "script=$(cat groovy/set_jenkins_root_cjoc.groovy)" \
     --user $USERNAME:$JENKINS_TOKEN \
     ${URL}/cjoc/scriptText

echo ""
