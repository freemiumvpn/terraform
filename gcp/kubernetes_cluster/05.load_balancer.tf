# docs: https://cloud.google.com/sdk/gcloud/reference/compute/http-health-checks/create
# example: gcloud compute http-health-checks create <name>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check
resource "google_compute_http_health_check" "default" {
  name    = "${var.namespace}-health-check"
  project = google_project.k8s_project.project_id

  host         = "kubernetes.default.svc.cluster.local"
  request_path = "/healthz"
}

# docs: https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create
# example: gcloud compute firewall-rules create <name> --allow tcp,udp,icmp --network <n> --source-ranges <r>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "health-check" {
  name        = "${var.namespace}-health-check"
  description = "k8s load balancer health check"
  project     = google_project.k8s_project.project_id
  network     = google_compute_network.vpc-network.id

  allow {
    protocol = "tcp"
  }

  direction     = "INGRESS"
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
}

# docs: https://cloud.google.com/sdk/gcloud/reference/compute/target-pools/create
# example: gcloud compute target-pools create <name>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_pool
resource "google_compute_target_pool" "default" {
  name    = "${var.namespace}-instance-pool"
  project = google_project.k8s_project.project_id
  region  = var.gcp_region

  instances = [
    "${var.gcp_zone}/controller-0",
    "${var.gcp_zone}/controller-1",
    "${var.gcp_zone}/controller-2",
  ]

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

# docs: https://cloud.google.com/sdk/gcloud/reference/compute/forwarding-rules/create
# example: gcloud compute forwarding-rules create <name>
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
resource "google_compute_forwarding_rule" "default" {
  name         = "${var.namespace}-forwarding-rule"
  project      = google_project.k8s_project.project_id
  region       = var.gcp_region
  network_tier = "STANDARD"

  ip_address = google_compute_address.k8s-address.address
  port_range = "6443"
  target     = google_compute_target_pool.default.id
}
