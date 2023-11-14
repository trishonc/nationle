resource "google_secret_manager_secret" "db_url" {
  secret_id = "nationledb_url"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_url" {
  secret    = google_secret_manager_secret.db_url.name
  secret_data = var.db_url_secret
}

resource "google_secret_manager_secret" "api_token" {
  secret_id = "nationle_token"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "api_token" {
  secret    = google_secret_manager_secret.api_token.name
  secret_data = var.secret_token
}





