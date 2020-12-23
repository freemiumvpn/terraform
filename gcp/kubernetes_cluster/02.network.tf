# docs: https://cloud.google.com/sdk/gcloud/reference/compute/networks/create
# example: gcloud compute networks create <name> --subnet-mode custom
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc-network" {
  name                    = "${var.namespace}-network"
  routing_mode            = "REGIONAL"
  project                 = google_project.k8s_project.project_id
  auto_create_subnetworks = false
}


# docs: https://cloud.google.com/sdk/gcloud/reference/compute/networks/subnets/create
# example: gcloud compute networks subnets create <name> --range 10.240.0.0/24 --network <vpc>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "vpc-subnetwork" {
  name          = "${var.namespace}-subnetwork"
  project       = google_project.k8s_project.project_id
  region        = var.gcp_region
  ip_cidr_range = "10.240.0.0/24"
  network       = google_compute_network.vpc-network.id
}
