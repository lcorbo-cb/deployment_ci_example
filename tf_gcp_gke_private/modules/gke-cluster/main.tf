resource "google_container_cluster" "cluster" {
  provider = google-beta

  name                     = var.name
  description              = var.description
  project                  = var.project
  location                 = var.location
  network                  = var.network
  subnetwork               = var.subnetwork
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  min_master_version       = "1.19.9-gke.1900"
  enable_legacy_abac       = false
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name = var.cluster_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = var.disable_public_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  network_policy {
    enabled = true

    provider = "CALICO"
  }

  vertical_pod_autoscaling {
    enabled = false
  }

  master_auth {
    username = ""
    password = ""
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.127.0.0/24"
    }
    cidr_blocks {
      cidr_block = "10.128.128.0/17"
    }
    cidr_blocks {
      cidr_block = "10.143.112.0/20"
    }
  }

  resource_labels = var.resource_labels
}

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name               = "private-pool"
  project            = var.project
  location           = var.location
  cluster            = google_container_cluster.cluster.name
  initial_node_count = "1"

  autoscaling {
    min_node_count = "5"
    max_node_count = "10"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type      = "COS"
    machine_type    = "e2-standard-2"
    disk_size_gb    = "100"
    disk_type       = "pd-standard"
    preemptible     = false
    service_account = var.service_account #module.gke_service_account.email

    labels = {
      private-pools-example = "true"
    }

    tags = [
      "public",
      "cbci-gke-public-allow-ingress"
    ]


    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
