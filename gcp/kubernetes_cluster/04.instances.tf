# docs: https://cloud.google.com/sdk/gcloud/reference/compute/addresses/create
# example: gcloud compute addresses create ...
# usage: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "controller" {
  for_each = var.controller_instances

  project        = google_project.k8s_project.project_id
  zone           = var.gcp_zone
  name           = "controller-${each.key}"
  machine_type   = "e2-medium"
  description    = "k8s controller node"
  can_ip_forward = true

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      image = "ubuntu-2004-focal-v20201211"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.vpc-network.id
    subnetwork = google_compute_subnetwork.vpc-subnetwork.id
    network_ip = "10.240.0.1${each.key}"

    access_config {
      network_tier = "STANDARD"
    }
  }


  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring",
    ]
  }
}


resource "google_compute_instance" "worker" {
  for_each = var.worker_instances

  project        = google_project.k8s_project.project_id
  zone           = var.gcp_zone
  name           = "worker-${each.key}"
  machine_type   = "e2-medium"
  description    = "k8s worker node"
  can_ip_forward = true

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      image = "ubuntu-2004-focal-v20201211"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.vpc-network.id
    subnetwork = google_compute_subnetwork.vpc-subnetwork.id
    network_ip = "10.240.0.2${each.key}"

    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata = {
    pod-cidr = "10.200.${each.key}.0/24"
  }

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring",
    ]
  }
}
