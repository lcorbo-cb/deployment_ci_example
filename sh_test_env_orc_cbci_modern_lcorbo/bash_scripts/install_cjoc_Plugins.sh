#!/usr/bin/env bash

URL=$1
USERNAME=$2
JENKINS_TOKEN=$(cat ../../sh_secrets_ps/dev_tokens/cjoc.token)

while read plugin; do
 curl --request POST \
      --header content-type:text/xml \
      --cacert ../../sh_secrets_ps/certs/ca/ca.pem \
      --user ${USERNAME}:${JENKINS_TOKEN} \
      --data-binary "<jenkins><install plugin=\"${plugin}@latest\" /></jenkins>" \
      ${URL}/cjoc/pluginManager/installNecessaryPlugins
  echo "Plugin: ${plugin} installed."
done < plugins/cjoc_plugins.txt
