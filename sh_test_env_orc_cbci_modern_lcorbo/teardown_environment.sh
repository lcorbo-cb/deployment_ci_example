#!/usr/bin/env bash
terraform -chdir=../tf_jenkins_team_masters destroy --auto-approve
terraform -chdir=../tf_jenkins_managed_masters destroy --auto-approve
terraform -chdir=../tf_jenkins_cjoc destroy --auto-approve
terraform -chdir=../tf_gcp_helm_cbci apply --auto-approve
terraform -chdir=../tf_gcp_helm_cbci destroy --auto-approve
#terraform -chdir=../tf_gcp_gke_private destroy --auto-approve
