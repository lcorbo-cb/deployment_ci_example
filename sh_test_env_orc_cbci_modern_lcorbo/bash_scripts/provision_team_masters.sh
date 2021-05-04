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
done < <(ls $MASTERS_PATH/masters/team_masters)

for i in "${array[@]}"; do
    bash bash_scripts/create_team_master.sh \
      $USERNAME \
      $JENKINS_TOKEN \
      $URL \
      $MASTERS_PATH/masters/team_masters/${i}
done

for i in "${array[@]}"; do
    echo "bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${i}"
    bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN teams-${i%%.*}
done

for i in "${array[@]}"; do
  controller="teams-$( echo ${i%%.*} | awk '{print tolower($0)}')"
  curl -X POST -H content-type:application/xml \
       -u $USERNAME:$JENKINS_TOKEN \
       -d @credentials/domains/user_github_domain.xml \
       ${URL}/${controller}/user/${USERNAME}/credentials/store/user/createDomain

  curl -X POST -H content-type:application/xml \
       -u $USERNAME:$JENKINS_TOKEN \
       -d @credentials/secrets/github_token_secret.xml \
       ${URL}/${controller}/user/${USERNAME}/credentials/store/user/domain/blueocean-github-domain/createCredentials

  kubectl annotate service ${controller} prometheus.io/scheme=http -n cloudbees-core
  kubectl annotate service ${controller} prometheus.io/path=/${controller}/prometheus/ -n cloudbees-core
  kubectl annotate service ${controller} prometheus.io/scrape=true -n cloudbees-core
  kubectl annotate service ${controller} prometheus.io/port=8080 -n cloudbees-core
done
