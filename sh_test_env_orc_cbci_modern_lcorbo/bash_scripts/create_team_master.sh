#!/bin/bash

USERNAME=$1
JENKINS_TOKEN=$2
URL=$3
TEAM_JSON=$4

curl -v POST \
     -u ${USERNAME}:${JENKINS_TOKEN} \
     -H "Content-Type: application/json" \
     --data-binary @$TEAM_JSON \
     "$URL/cjoc/blue/rest/cjoc/teams/"
