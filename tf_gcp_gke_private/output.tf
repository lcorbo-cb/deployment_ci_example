output "cluster_name" {
  value = module.gke_cluster.name
}

output "cluster_ca_certificate" {
  value = base64encode(module.gke_cluster.cluster_ca_certificate)
}

output "client_certificate" {
  value = module.gke_cluster.client_certificate
}

output "client_key" {
  value = module.gke_cluster.client_key
}

output "endpoint" {
  value = module.gke_cluster.endpoint
}
