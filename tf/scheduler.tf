resource "google_cloud_scheduler_job" "rotate_country" {
  name = "rotate_country_job"
  schedule = "0 23 * * *"

  http_target {
    http_method = "POST"
    uri = "${google_cloud_run_v2_service.cloud_run_backend.uri}/new_country"
    headers = {
      "Authorization" = google_secret_manager_secret_version.api_token.secret_data
    }
  }
}

resource "google_cloud_scheduler_job" "keep_warm" {
  name = "keep_warm_job"
  schedule = "*/5 * * * *"

  http_target {
    http_method = "GET"
    uri = google_cloud_run_v2_service.cloud_run_frontend.uri
  }
}
