resource "google_compute_subnetwork" "public" {
  name                     = "${var.name}-subnet"
  ip_cidr_range            = cidrsubnet(var.ip_cidr_range, 1, 0)
  network                  = var.network
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "public-services"
    ip_cidr_range = cidrsubnet(var.ip_cidr_range, 1, 1)
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-router-nat"
  router                             = var.router
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.public.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
