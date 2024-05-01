module "gke_cluster" {
  source         = "github.com/romanfeshchak/terraform-gke-cluster"
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GOOGLE_REGION  = var.GOOGLE_REGION
  GKE_NUM_NODES  = var.GKE_NUM_NODES
}

resource "google_compute_global_address" "vpc_ip" {
  name          = "vpc-ip"
  purpose       = "VPC_PEERING"
  address_type  = "EXTERNAL"
  prefix_length = 16
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

provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
}

resource "google_container_cluster" "terraincognitus" {
  name     = var.GKE_CLUSTER_NAME
  location = var.GOOGLE_REGION

  initial_node_count       = var.GKE_NUM_NODES
  remove_default_node_pool = true
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
    bucket  = "terraforms-state"
    prefix  = "terraform/state"
  }
}
