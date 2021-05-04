module "subnets_public" {
  source        = "./modules/tf_gcp_networking_subnet_public"
  network       = data.terraform_remote_state.persist.outputs.networking.network.name
  router        = data.terraform_remote_state.persist.outputs.networking.router.name
  ip_cidr_range = "10.128.0.0/16"
  name          = "cbci-gke-subnetwork-public"
  project       = data.terraform_remote_state.project.outputs.project
  region        = data.terraform_remote_state.project.outputs.region
}

module "subnets_private" {
  source        = "./modules/tf_gcp_networking_subnet_private"
  network       = data.terraform_remote_state.persist.outputs.networking.network.name
  ip_cidr_range = "10.129.0.0/16"
  name          = "cbci-gke-subnetwork-private"
  project       = data.terraform_remote_state.project.outputs.project
  region        = data.terraform_remote_state.project.outputs.region
}

module "network_firewall" {
  source = "./modules/network-firewall"

  name_prefix        = "cbci-gke"
  project            = data.terraform_remote_state.project.outputs.project
  network            = data.terraform_remote_state.persist.outputs.networking.network.name
  public_subnetwork  = module.subnets_public.subnet.self_link
  # private_subnetwork = module.subnets_private.subnet.self_link
}

module "gke_service_account" {
  source = "./modules/gke-service-account"

  name        = var.cluster_service_account_name
  project     = data.terraform_remote_state.project.outputs.project
  description = var.cluster_service_account_description
}

module "gke_cluster" {
  source = "./modules/gke-cluster"

  name                         = var.cluster_name
  project                      = data.terraform_remote_state.project.outputs.project
  location                     = data.terraform_remote_state.project.outputs.region
  network                      = data.terraform_remote_state.persist.outputs.networking.network.name
  subnetwork                   = module.subnets_public.subnet.name
  master_ipv4_cidr_block       = var.master_ipv4_cidr_block
  enable_private_nodes         = "true"
  disable_public_endpoint      = "true"
  cluster_secondary_range_name = module.subnets_public.subnet.secondary_ip_range[0].range_name
  service_account              = module.gke_service_account.email
  resource_labels = {
    environment = "cbci-demo-cluster"
  }
}
