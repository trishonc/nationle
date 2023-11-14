resource "google_artifact_registry_repository" "nationle-frontend" {
  location      = var.region
  repository_id = "nationle-frontend"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "nationle-backend" {
  location      = var.region
  repository_id = "nationle-backend"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "cloud_run_frontend" {
  name     = "nationle-frontend"
  location = var.region
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.service_account
    containers {
      image = "europe-west3-docker.pkg.dev/nationle-403218/nationle-frontend/frontend:latest"
      env {
        name = "SECRET_BACKEND_URL"
        value = "https://nationle-backend-a2ks77mfya-ey.a.run.app"
        }
      env {
        name = "SECRET_TOKEN"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.api_token.id
            version = "latest"
          }
        }
      }
      }
    }
    depends_on = [google_secret_manager_secret_version.api_token]
  }


resource "google_cloud_run_v2_service" "cloud_run_backend" {
  name     = "nationle-backend"
  location = var.region
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    vpc_access {
      connector = google_vpc_access_connector.function_connector.id
      egress = "ALL_TRAFFIC"
    }
    service_account = var.service_account
    containers {
      image = "europe-west3-docker.pkg.dev/nationle-403218/nationle-backend/backend:latest"
      env {
        name = "DB_URI"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.db_url.id
            version = "latest"
          }
        }
      }
      env {
        name = "FRONTEND_URL"
        value = "https://nationle-frontend-a2ks77mfya-ey.a.run.app"
      }
      env {
        name = "SECRET_TOKEN"
         value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.api_token.id
            version = "latest"
          }
        }
      }
    }
  }
  depends_on = [google_secret_manager_secret_version.api_token]
}