#!/usr/bin/env bash

NAMESPACE=${1}

kubectl cp ../../sh_secrets_ps/init/01_create_admin.groovy                        ${NAMESPACE}/cjoc-0:/var/jenkins_home/init.groovy.d/01_create_admin.groovy
kubectl cp ../../sh_secrets_ps/init/02_add_license.groovy                         ${NAMESPACE}/cjoc-0:/var/jenkins_home/init.groovy.d/02_add_license.groovy
kubectl cp ../../sh_secrets_ps/license/jenkins_key.txt                            ${NAMESPACE}/cjoc-0:/var/jenkins_home/jenkins_key.txt
kubectl cp ../../sh_secrets_ps/license/jenkins_cert.txt                           ${NAMESPACE}/cjoc-0:/var/jenkins_home/jenkins_cert.txt

kubectl exec cjoc-0 --namespace ${NAMESPACE} -- sh -c "echo 2.277.1.2 > /var/jenkins_home/jenkins.install.UpgradeWizard.state"
kubectl exec cjoc-0 --namespace ${NAMESPACE} -- sh -c "echo 2.277.1.2 > /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion"

kubectl delete pods cjoc-0  --namespace ${NAMESPACE}
