resource "google_sql_database_instance" "this" {
  name             = "nationledb"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = google_compute_network.nationle.id
      enable_private_path_for_google_cloud_services = true
      authorized_networks {
        value = var.ip
      }
    }
  }
}

resource "google_sql_database" "nationledb" {
  instance = google_sql_database_instance.this.name
  name     = "nationledb"
}

