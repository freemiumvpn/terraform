# # docs: https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create
# # example: gcloud compute firewall-rules create <name> --allow tcp,udp,icmp --network <n> --source-ranges <r>
# # usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "vpn" {
  name        = "${var.namespace}-service-vpn"
  description = "service: vpn firewall"
  project     = google_project.k8s_project.project_id
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.kops_cluster_tag]
}

# docs: https://cloud.google.com/sdk/gcloud/reference/compute/addresses/create
# example: gcloud compute addresses create <name> --region <r>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "vpn-address" {
  project      = google_project.k8s_project.project_id
  region       = var.gcp_region
  name         = "${var.namespace}-vpn-address"
  description  = "VPN External IP"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

# docs: https://cloud.google.com/sdk/gcloud/reference/compute/forwarding-rules/create
# example: gcloud compute forwarding-rules create <name>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
resource "google_compute_forwarding_rule" "default" {
  name         = "${var.namespace}-vpn-forwarding-rule"
  description  = "forwards vpn ip to k8s nodes pool"
  project      = google_project.k8s_project.project_id
  region       = var.gcp_region
  network_tier = "STANDARD"

  ip_protocol = "TCP"
  port_range  = "443"

  ip_address = google_compute_address.vpn-address.address
  target     = var.kops_cluster_target
}
