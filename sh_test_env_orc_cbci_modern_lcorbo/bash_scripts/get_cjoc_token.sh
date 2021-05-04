#!/usr/bin/env bash

URL=$1
USERNAME=$2
PASSWORD=$3

JENKINS_CRUMB=$( \
 curl ${URL}/cjoc/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\) \
   --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
   --cookie-jar .cookies.txt \
   --silent \
   --user $USERNAME:$PASSWORD \
)

JENKINS_TOKENS_JSON=$( \
   curl ${URL}/cjoc/user/${USERNAME}/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken \
     --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
     --header "$JENKINS_CRUMB" \
     --user $USERNAME:$PASSWORD \
     --silent \
     --data "newTokenName=$USERNAME" \
     --cookie .cookies.txt
)

JENKINS_TOKEN_VALUE=$( \
  echo $JENKINS_TOKENS_JSON | jq '.data.tokenValue' \
)

JENKINS_TOKEN=$(sed -e 's/^"//' -e 's/"$//' <<<"$JENKINS_TOKEN_VALUE")

echo $JENKINS_TOKEN > ../../sh_secrets_ps/dev_tokens/cjoc.token
