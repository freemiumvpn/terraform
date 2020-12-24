# docs: https://cloud.google.com/sdk/gcloud/reference/compute/addresses/create
# example: gcloud compute addresses create <name> --region <r>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "k8s-address" {
  project      = google_project.k8s_project.project_id
  region       = var.gcp_region
  name         = "${var.namespace}-address"
  description  = "K8s External IP"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}
