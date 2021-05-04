#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)
MASTERS_PATH="../sh_cbci_casc_demo_deployment"

i=0
while read line
do
    array[ $i ]="$line"
    (( i++ ))
done < <(ls $MASTERS_PATH/masters/managed_masters)

for i in "${array[@]}"; do
    # API documentation
    # https://docs.cloudbees.com/docs/cloudbees-ci-api/latest/bundle-management-api
    bash bash_scripts/create_managed_master.sh \
      $USERNAME \
      $JENKINS_TOKEN \
      $URL \
      $MASTERS_PATH/masters/managed_masters/${i} \
      $MASTERS_PATH/services_annotations/managed_masters/${i}
done

for i in "${array[@]}"; do
    echo "bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${i}"
    bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${i%%.*}
done
