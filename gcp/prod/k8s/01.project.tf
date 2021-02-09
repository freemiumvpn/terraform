# Creates a project namespace

resource "google_project" "k8s_project" {
  name            = var.namespace
  project_id      = var.namespace
  billing_account = var.gcp_billing_account
  org_id          = var.gcp_org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project                    = google_project.k8s_project.project_id
  disable_on_destroy         = true
  disable_dependent_services = true
}
