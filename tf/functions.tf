resource "google_cloudfunctions2_function" "resize_photo" {
  name    = "resize_photo"
  location = var.region

  build_config {
    runtime = "python311"
    entry_point = "Handler"
    source {
      storage_source {
        bucket = google_storage_bucket.source_archive_bucket.name
        object = google_storage_bucket_object.resize_photo_source.name
      }

    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "512M"
    timeout_seconds     = 60
    service_account_email  = var.service_account
  }

  event_trigger {
    trigger_region        = var.region
    event_type            = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_DO_NOT_RETRY"
    service_account_email = var.service_account
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.original.name
    }
  }
}

resource "google_cloudfunctions2_function" "store_url" {
  name    = "store_url"
  location = var.region

  build_config {
    runtime = "python311"
    entry_point = "Handler"
    source {
      storage_source {
        bucket = google_storage_bucket.source_archive_bucket.name
        object = google_storage_bucket_object.store_url_source.name
      }

    }
  }

  service_config {
    max_instance_count  = 2
    available_memory    = "512M"
    available_cpu       = 1
    timeout_seconds     = 60
    service_account_email  = var.service_account
    vpc_connector = google_vpc_access_connector.function_connector.id
    vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"

    secret_environment_variables {
      project_id = var.project_id
      key        = "DATABASE_URL"
      secret     = google_secret_manager_secret.db_url.secret_id
      version    = "latest"
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_DO_NOT_RETRY"
    service_account_email = var.service_account
    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.resized.name
    }
  }
  depends_on = [google_secret_manager_secret_version.db_url]
}



