# see https://cloud.google.com/sdk/gcloud/reference/compute/networks/create
# see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# gcloud compute networks create <name> --subnet-mode custom

resource "google_compute_network" "vpc_network" {
  name                    = "${var.namespace}-network"
  routing_mode            = "REGIONAL"
  project                 = google_project.k8s_project.project_id
  auto_create_subnetworks = false
}
