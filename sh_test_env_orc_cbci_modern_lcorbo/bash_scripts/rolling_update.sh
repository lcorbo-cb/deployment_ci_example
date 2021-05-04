#!/usr/bin/env bash

NAMESPACE=${1}

kubectl cp config/cb-envelope/envelope.json  ${NAMESPACE}/cjoc-0:/var/jenkins_home/cb-envelope/envelope.json
kubectl exec cjoc-0 --namespace ${NAMESPACE} -- sh -c "cd /var/jenkins_home/cb-envelope/core-oc-2.277.2.3-2/ && curl -O https://jenkins-updates.cloudbees.com/download/plugins/aws-credentials/1.28.1/aws-credentials.hpi"
kubectl exec cjoc-0 --namespace ${NAMESPACE} -- sh -c "cd /var/jenkins_home/cb-envelope/core-oc-2.277.2.3-2/ && curl -O https://jenkins-updates.cloudbees.com/download/plugins/plugin-util-api/1.7.1/plugin-util-api.hpi"
kubectl exec cjoc-0 --namespace ${NAMESPACE} -- sh -c "cd /var/jenkins_home/cb-envelope/core-oc-2.277.2.3-2/ && curl -O https://jenkins-updates.cloudbees.com/download/plugins/nectar-rbac/5.56/nectar-rbac.hpi"

sleep 240
