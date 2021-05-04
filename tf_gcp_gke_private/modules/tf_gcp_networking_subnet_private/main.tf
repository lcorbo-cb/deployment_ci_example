resource "google_compute_subnetwork" "private" {
  name                     = "${var.name}-subnet"
  ip_cidr_range            = cidrsubnet(var.ip_cidr_range, 1, 0)
  network                  = var.network
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "private-services"
    ip_cidr_range = cidrsubnet(var.ip_cidr_range, 1, 1)
  }
}
