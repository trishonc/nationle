provider "google" {
    region = var.region
    project = var.project_id
    credentials = "../nationle-key.json"
}

provider "archive" {}
