resource "google_storage_bucket" "kops-state" {
  name          = "${var.namespace}-kops-state"
  location      = "EU"
  project       = google_project.k8s_project.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}
