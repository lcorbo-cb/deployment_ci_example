#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)
MASTERS_PATH="../sh_cbci_casc_demo_deployment/casc/managed_masters"

i=0
while read line
do
    array[ $i ]="$line"
    (( i++ ))
done < <(ls $MASTERS_PATH)

for i in "${array[@]}"; do
  kubectl cp "$MASTERS_PATH/${i}" cjoc-0:/var/jenkins_home/jcasc-bundles-store/ -n cloudbees-core
done

j=0
for j in "${folders[@]}"; do
  i=0
  while read line; do
    array[ $i ]="$line"
    (( i++ ))
  done < <(ls $MASTERS_PATH/masters/managed_masters/${j%%/}/*.yaml)

  for i in "${array[@]}"; do
    i=${i%.*}; i=${i##*/}

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
       -XPOST "${URL}/cjoc/casc-bundle/set-master-to-bundle?bundleId=$i&masterPath=${j%%/}-${i}"
  done
done
