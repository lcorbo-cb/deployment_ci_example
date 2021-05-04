module "cbci" {
  source   = "./modules/tf_gcp_helm_cbci_ingress"
  dns_name = data.terraform_remote_state.persist.outputs.dns.dns_name
  name     = data.terraform_remote_state.persist.outputs.dns.name
}
