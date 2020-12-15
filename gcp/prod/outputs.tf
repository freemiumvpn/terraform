output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  value = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "region" {
  description = "Cluster region"
  value       = module.gke.region
}

output "location" {
  description = "Cluster location (zones)"
  value       = module.gke.location
}

output "project_id" {
  description = "Project id where GKE cluster is created."
  value       = var.project_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "k8s_service_account_email" {
  description = "K8S GCP service account."
  value       = module.workload_identity.gcp_service_account_email
}

output "k8s_service_account_name" {
  description = "K8S GCP service name"
  value       = module.workload_identity.gcp_service_account_name
}
