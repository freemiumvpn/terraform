provider "google" {
  version = "~> 3.42.0"
  region  = var.region
}

provider "kubernetes" {
  version                = "~> 1.10, != 1.11.0"
  host                   = module.gke.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  load_config_file       = false
}
