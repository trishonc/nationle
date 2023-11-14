variable "project_id" {
    type = string
    default = "nationle-403218"
}

variable "region" {
    type = string
    default = "europe-west3"
}

variable "service_account" {
    type = string
    default = "nationlesa@nationle-403218.iam.gserviceaccount.com"
}

variable "db_url_secret" {
    type = string
    sensitive = true
}

variable "secret_token" {
    type = string
    sensitive = true
}

variable "ip" {
    type = string
    sensitive = true
}
