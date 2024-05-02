provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
  credentials = file(var.SRVC_JSON)
}

module "gke_cluster" {
  source = "terraform-google-modules/kubernetes-engine/google"

  project_id        = var.GOOGLE_PROJECT
  region            = var.GOOGLE_REGION
  network           = google_compute_network.vpc.self_link
  subnetwork        = google_compute_subnetwork.subnet.self_link
  name              = var.GKE_CLUSTER_NAME
  ip_range_pods     = var.GKE_CLUSTER_PODS_IP_RANGE
  ip_range_services = var.GKE_CLUSTER_SERVICES_IP_RANGE
}

resource "google_compute_network" "vpc" {
  name                    = var.VPC_NAME
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet"
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = var.GKE_SUBNET_CIDR_BLOCK
  region        = var.GOOGLE_REGION
}

resource "google_container_cluster" "terraincognitus" {
  name     = var.GKE_CLUSTER_NAME
  location = var.GOOGLE_REGION

  initial_node_count       = var.GKE_NUM_NODES
  remove_default_node_pool = true

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = var.GKE_PODS_SECONDARY_RANGE_NAME
    services_secondary_range_name = var.GKE_SERVICES_SECONDARY_RANGE_NAME
  }
}

resource "google_container_node_pool" "terraincognitus" {
  name       = var.GKE_POOL_NAME
  project    = google_container_cluster.terraincognitus.project
  cluster    = google_container_cluster.terraincognitus.name
  location   = google_container_cluster.terraincognitus.location
  node_count = var.GKE_NUM_NODES

  node_config {
    preemptible  = true
    machine_type = var.GKE_MACHINE_TYPE
  }

  node_locations = [var.GOOGLE_REGION]
}

terraform {
  backend "gcs" {
    bucket = "terraforms-state"
    prefix = "terraform/state"
  }
}
