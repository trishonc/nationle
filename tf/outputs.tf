output "frontend_url" {
  value = google_cloud_run_v2_service.cloud_run_frontend.uri
}

output "backend_url" {
  value = google_cloud_run_v2_service.cloud_run_backend.uri
}