#!/bin/bash

USERNAME=$1
JENKINS_TOKEN=$2
DOMAIN_NAME=$3
CONFIG_FILE=$4
YAMLTOMERGE=$(cat $5)
YAML_CONFIG=$(cat $CONFIG_FILE)
MASTERNAME="${CONFIG_FILE##*/}"; MASTERNAME="${MASTERNAME%%.*}"

Groovy_Script="""
  import com.cloudbees.masterprovisioning.kubernetes.KubernetesMasterProvisioning
  import com.cloudbees.opscenter.server.casc.BundleStorage
  import com.cloudbees.opscenter.server.model.ManagedMaster
  import com.cloudbees.opscenter.server.model.OperationsCenter
  import com.cloudbees.opscenter.server.properties.ConnectedMasterLicenseServerProperty
  import hudson.ExtensionList
  import jenkins.model.Jenkins
  import org.apache.commons.io.FileUtils
  import org.yaml.snakeyaml.Yaml
  import groovy.json.JsonSlurper

  String masterName = '${MASTERNAME}'
  String yamlToMerge = '''${YAMLTOMERGE}'''
  def configText = '''${YAML_CONFIG}'''
  def yaml = new Yaml()
  def config = yaml.load(configText)
  def configuration = new KubernetesMasterProvisioning()

  config.each { key, value ->
      configuration.\"\$key\" = value
  }

  configuration.yaml = yamlToMerge




  ManagedMaster master = Jenkins.instance.createProject(ManagedMaster.class, masterName)
  master.setConfiguration(configuration)
  master.properties.replace(new ConnectedMasterLicenseServerProperty(null))
  master.save()
  master.onModified()
  println \"Provision and start...\"
  master.provisionAndStartAction();
"""

curl -v \
     -d "script=${Groovy_Script}" \
     -u ${USERNAME}:${JENKINS_TOKEN} \
     --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
     --cookie .cookies.txt \
     ${DOMAIN_NAME}/cjoc/scriptText
