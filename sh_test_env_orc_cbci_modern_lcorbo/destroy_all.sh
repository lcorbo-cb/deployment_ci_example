#!/usr/bin/env bash

# terraform -chdir=../tf_gcp_gke_cbci       init
# terraform -chdir=../tf_gcp_gke_cbci       destroy --auto-approve
# terraform -chdir=../tf_gcp_compute_cbci   init
# terraform -chdir=../tf_gcp_compute_cbci   destroy --auto-approve
# terraform -chdir=../tf_gcp_compute_vpn    init
#terraform -chdir=../tf_gcp_compute_vpn    destroy --auto-approve
# terraform -chdir=../tf_gcp_persist_lcorbo init
# terraform -chdir=../tf_gcp_persist_lcorbo destroy --auto-approve
# terraform -chdir=../tf_gcp_project_lcorbo init
terraform -chdir=../tf_gcp_project_lcorbo destroy --auto-approve
