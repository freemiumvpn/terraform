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


# docs: https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create
# example: gcloud compute firewall-rules create <name> --allow tcp,udp,icmp --network <n> --source-ranges <r>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

resource "google_compute_firewall" "internal" {
  name        = "${var.namespace}-firewall-internal"
  description = "Internal k8s firewall"
  project     = google_project.k8s_project.project_id
  network     = google_compute_network.vpc-network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  direction     = "INGRESS"
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}
