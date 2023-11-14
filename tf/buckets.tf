resource "google_storage_bucket" "original" {
  location = "europe-west3"
  name     = "nationle-og"
}

resource "google_storage_bucket" "resized" {
  location = "europe-west3"
  name     = "nationle-resized"
}

resource "google_storage_bucket" "source_archive_bucket" {
  name     = "nationle_functions_source"
  location = "europe-west3"
  uniform_bucket_level_access = true
}

data archive_file "resize_source_archive" {
  type = "zip"
  source_dir = "../functions/resize_photo"
  output_path = "../functions/resize_photo.zip"
}

resource "google_storage_bucket_object" "resize_photo_source" {
  name   = "resize_photo.zip"
  bucket = google_storage_bucket.source_archive_bucket.name
  source = "../functions/resize_photo.zip"
  depends_on = [data.archive_file.resize_source_archive]
}

data archive_file "add_urls_source_archive" {
  type = "zip"
  source_dir = "../functions/store_url"
  output_path = "../functions/store_url.zip"
}

resource "google_storage_bucket_object" "store_url_source" {
  name   = "store_url.zip"
  bucket = google_storage_bucket.source_archive_bucket.name
  source = "../functions/store_url.zip"
  depends_on = [data.archive_file.add_urls_source_archive]
}

resource "google_storage_bucket" "flags" {
  location = var.region
  name     = "nationle-flags"
}

resource "google_storage_bucket" "db_data" {
  location = var.region
  name     = "nationle-data"
}

resource "google_storage_bucket_object" "db_data" {
  name     = "data.sql"
  bucket   = google_storage_bucket.db_data.name
  source = "../db_data.sql"
}



