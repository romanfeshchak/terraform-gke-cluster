#terraform {
#  backend "gcs" {
#    bucket = "terraform-state"
#    prefix = "terraform/state"
#  }
#}

module "gke_cluster" {
  source         = "github.com/romanfeshchak/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}

provider "google" {
  # Configuration options
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}



resource "google_container_cluster" "terraincognitus" {
  name     = var.GKE_CLUSTER_NAME
  location = var.GOOGLE_REGION

  initial_node_count       = 1
  remove_default_node_pool = true
}
resource "google_container_node_pool" "terraincognitus" {
  name       = var.GKE_POOL_NAME
  project    = google_container_cluster.terraincognitus.project
  cluster    = google_container_cluster.terraincognitus.name
  location   = google_container_cluster.terraincognitus.location
  node_count = var.GKE_NUM_NODES

  node_config {
    machine_type = var.GKE_MACHINE_TYPE
  }
}

module "gke_auth" {
  depends_on = [
    google_container_cluster.terraincognitus
  ]
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version      = ">= 24.0.0"
  project_id   = var.GOOGLE_PROJECT
  cluster_name = google_container_cluster.terraincognitus.name
  location     = var.GOOGLE_REGION
}
