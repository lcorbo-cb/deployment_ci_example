#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)

curl --request POST \
     --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
     --user ${USERNAME}:${JENKINS_TOKEN} \
     ${URL}/cjoc/safeRestart

sleep 10
echo "Restarting cjoc."
