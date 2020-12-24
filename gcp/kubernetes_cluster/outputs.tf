output "project_id" {
  value = google_project.k8s_project.project_id
}

output "static_ip" {
  value = google_compute_address.k8s-address.address
}
