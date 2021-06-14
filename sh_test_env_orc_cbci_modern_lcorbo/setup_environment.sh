#!/usr/bin/env bash

git_user="lcorbo-cb"
root_dir=$PWD
NAMESPACE="cloudbees-core"
USERNAME="admin"
PASSWORD="welcome"

apply_tf_environment () {
  cd ../
  if [ ! -d $1 ]; then
    git clone https://github.com/$git_user/${1}.git
  fi
  cd $root_dir
  terraform -chdir=../${1} init
  terraform -chdir=../${1} apply --auto-approve
}

apply_tf_environment tf_gcp_gke_private
apply_tf_environment tf_gcp_helm_cbci

URL=$(terraform -chdir=../tf_gcp_helm_cbci output url | sed -e 's/^"//' -e 's/"$//')
CLUSTERNAME=$(terraform -chdir=../tf_gcp_gke_private output cluster_name | sed -e 's/^"//' -e 's/"$//')

gcloud container clusters get-credentials --internal-ip $CLUSTERNAME --region us-central1
bash bash_scripts/prep_cjoc_fs.sh $NAMESPACE
bash bash_scripts/wait_for_controller.sh $URL $USERNAME $PASSWORD "cjoc"
bash bash_scripts/get_cjoc_token.sh $URL $USERNAME $PASSWORD
bash bash_scripts/install_cjoc_plugins.sh $URL $USERNAME
bash bash_scripts/rolling_update.sh $NAMESPACE
bash bash_scripts/restart_cjoc.sh $URL $USERNAME
bash bash_scripts/wait_for_controller.sh $URL $USERNAME $PASSWORD "cjoc"
bash bash_scripts/set_cjoc_root.sh $URL $USERNAME
bash bash_scripts/config_health_adviser.sh $URL $USERNAME
apply_tf_environment tf_jenkins_cjoc
echo "Cloudbees Modern inital setup complete."
#
# bash bash_scripts/upload_casc_bundle.sh $URL $USERNAME
# # bash bash_scripts/upload_team_casc_bundle.sh $URL $USERNAME
# bash bash_scripts/provision_managed_masters.sh $URL $USERNAME
# # bash bash_scripts/provision_team_masters.sh $URL $USERNAME
# apply_tf_environment tf_jenkins_managed_masters
# apply_tf_environment tf_jenkins_team_masters
