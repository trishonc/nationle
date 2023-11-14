resource "google_compute_network" "nationle" {
  name = "nationle"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  ip_cidr_range = "10.0.0.0/24"
  name          = "nationle-public"
  network = google_compute_network.nationle.id
}

resource "google_compute_subnetwork" "private" {
  ip_cidr_range = "10.0.1.0/24"
  name          = "nationle-private"
  network = google_compute_network.nationle.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "nationle-router"
  network = google_compute_network.nationle.id
  region = var.region
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gw" {
  name    = "nationle-nat-gw"
  nat_ip_allocate_option = "AUTO_ONLY"
  router = google_compute_router.router.name
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name = "cloudsql-private-ip"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = google_compute_network.nationle.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.nationle.id
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  service                 = "servicenetworking.googleapis.com"
}

resource "google_vpc_access_connector" "function_connector" {
  name          = "nationle-connector"
  region        = var.region
  network       = google_compute_network.nationle.id
  ip_cidr_range = "10.8.0.0/28"
}