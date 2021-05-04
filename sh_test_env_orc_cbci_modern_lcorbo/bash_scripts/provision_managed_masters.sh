#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)
MASTERS_PATH="../sh_cbci_casc_demo_deployment"

# Get first level subfolders
SCRIPTDIR=$(pwd)
cd ../sh_cbci_casc_demo_deployment/masters/managed_masters/
i=0
while read line; do
  folders[ $i ]="$line"
  (( i++ ))
done < <(ls -d */)
cd $SCRIPTDIR

j=0
for j in "${folders[@]}"; do
  i=0
  while read line; do
    array[ $i ]="$line"
    (( i++ ))
  done < <(ls $MASTERS_PATH/masters/managed_masters/${j%%/}/*.yaml)

  for i in "${array[@]}"; do
    i=${i%.*}; i=${i##*/}
    bash bash_scripts/create_managed_master.sh \
      $USERNAME \
      $JENKINS_TOKEN \
      $URL \
      $MASTERS_PATH/masters/managed_masters/${j%%/}/${i} \
      $MASTERS_PATH/services_annotations/managed_masters/${j%%/}/${i} \
      ${j%%/}
      echo "i: ${i}, j: ${j%%/}"
  done
done

echo "Gate 3"
i=0
while read line
do
    mmarray[ $i ]="$line"
    (( i++ ))
done < <(ls $MASTERS_PATH/masters/managed_masters/*.yaml)

echo "Gate 4"
i=0
while read line
do
     rlarray[ $i ]="$line"
    (( i++ ))
done < <(ls $MASTERS_PATH/masters/managed_masters/*.yaml)

echo "Gate 5"
for i in "${rlarray[@]}"; do
    i=${i%.*}; i=${i##*/}
    echo "i: ${i}"
    bash bash_scripts/create_managed_master0.sh \
      $USERNAME \
      $JENKINS_TOKEN \
      $URL \
      $MASTERS_PATH/masters/managed_masters/${i} \
      $MASTERS_PATH/services_annotations/managed_masters/${i}
done

echo "Gate 6"

j=0
for j in "${folders[@]}"; do
  i=0
  while read line; do
    array[ $i ]="$line"
    (( i++ ))
  done < <(ls $MASTERS_PATH/masters/managed_masters/${j%%/}/*.yaml)

  for i in "${array[@]}"; do
    i=${i%.*}; i=${i##*/}
    echo "bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${j%%/}-${i}"
    bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${j%%/}-${i}
  done
done

echo "Gate 7"

i=0
for i in "${rlarray[@]}"; do
    i=${i%.*}; i=${i##*/}
    echo "bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${i}"
    bash bash_scripts/wait_for_controller.sh $URL $USERNAME $JENKINS_TOKEN ${i}
done
