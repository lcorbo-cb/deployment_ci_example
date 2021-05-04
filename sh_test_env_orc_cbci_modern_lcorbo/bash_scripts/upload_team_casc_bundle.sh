#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)
MASTERS_PATH="../sh_cbci_casc_demo_deployment/casc/team_masters"

i=0
while read line
do
    array[ $i ]="$line"
    (( i++ ))
done < <(ls $MASTERS_PATH)

for i in "${array[@]}"; do
  kubectl cp "$MASTERS_PATH/${i}" cjoc-0:/var/jenkins_home/jcasc-bundles-store/ -n cloudbees-core
done

for i in "${array[@]}"; do
   curl \
      --write-out "%{http_code}" \
      --silent \
      --output /dev/null \
      --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
      --user $USERNAME:$JENKINS_TOKEN \
      -XPOST "${URL}/cjoc/casc-bundle/regenerate-token?bundleId=$i"

    curl \
      --write-out "%{http_code}" \
      --silent \
      --output /dev/null \
      --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
      --user $USERNAME:$JENKINS_TOKEN \
      -XPOST "${URL}/cjoc/casc-bundle/set-master-to-bundle?bundleId=$i&masterPath=Teams/$i"
done
