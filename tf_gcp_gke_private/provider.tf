provider "google" {
  project = data.terraform_remote_state.project.outputs.project
  region  = data.terraform_remote_state.project.outputs.region
}

provider "google-beta" {
  project = data.terraform_remote_state.project.outputs.project
  region  = data.terraform_remote_state.project.outputs.region
}

terraform {
  backend "gcs" {
    bucket = "lcorbo-sandbox-d79dc401"
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
