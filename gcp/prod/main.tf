data "google_client_config" "default" {}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region
  zones      = var.zones

  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods
  ip_range_services        = var.ip_range_services
  identity_namespace       = "${var.project_id}.svc.id.goog"
  remove_default_node_pool = true
  service_account          = "create"
  node_metadata            = "GKE_METADATA_SERVER"
  node_pools = [
    {
      name         = "${var.cluster_name}-node-pool"
      auto_repair  = true
      auto_scaling = false
      auto_upgrade = true

      disk_type    = "pd-standard"
      disk_size_gb = 100

      machine_type      = "e2-standard-4"
      min_count         = 1
      max_count         = 1
      max_pods_per_node = 100
      max_unavailable   = 0

      image_type = "COS"
    }
  ]
}


# Required for external-dns
# see https://github.com/kubernetes-sigs/external-dns/issues/509#issuecomment-589336064
module "workload_identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "iden-${module.gke.name}"
  project_id          = var.project_id
  namespace           = "default"
  use_existing_k8s_sa = false
}
