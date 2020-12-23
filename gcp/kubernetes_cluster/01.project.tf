# Creates a project namespace for the cluster

resource "google_project" "k8s-project" {
  name       = var.project_id
  project_id = var.project_id
}
