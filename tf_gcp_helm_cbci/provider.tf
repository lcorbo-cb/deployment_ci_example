provider "google" {
  project = data.terraform_remote_state.project.outputs.project
  region  = data.terraform_remote_state.project.outputs.region
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.cluster.outputs.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.terraform_remote_state.cluster.outputs.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
  }
}

# terraform {
#   backend "gcs" {
#     bucket = "lcorbo-sandbox-d79dc401"
#     prefix = "cbci_helm_state"
#   }
# }

data "terraform_remote_state" "cluster" {
  backend = "gcs"
  config = {
    bucket = data.terraform_remote_state.project.outputs.project
    prefix = "cbci_gke_state"
  }
}

data "terraform_remote_state" "project" {
  backend = "gcs"
  config = {
    bucket = "lcorbo-sandbox-d79dc401"
    prefix = "project_state"
  }
}

data "terraform_remote_state" "persist" {
  backend = "gcs"
  config = {
    bucket = data.terraform_remote_state.project.outputs.project
    prefix = "persist_state"
  }
}
