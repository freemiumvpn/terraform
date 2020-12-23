provider "google" {
  version = "~> 3.42.0"
  region  = var.region
}

data "google_client_config" "default" {}
