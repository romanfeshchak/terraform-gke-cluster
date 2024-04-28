terraform {
  backend "gcs" {
    bucket = var.bucket_name
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.google_project
  region  = var.google_region
  credentials = file(var.google_credentials_file)
}

resource "google_container_cluster" "terraincognitus" {
  name     = var.cluster_name
  location = var.google_region

  initial_node_count = var.node_count
  node_config {
    machine_type = var.machine_type
  }
}

resource "google_compute_network" "kubernetes" {
  name = var.cluster_name
}

resource "google_compute_subnetwork" "kubernetes" {
  name          = var.cluster_name
  ip_cidr_range = var.cluster_network_cidr_block
  region        = var.google_region
  network       = google_compute_network.kubernetes.name
}

resource "google_container_node_pool" "terraincognitus" {
  name       = var.node_pool_name
  cluster    = google_container_cluster.terraincognitus.name
  region    = var.google_region
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    preemptible  = true # Зниження витрат на ноди
  }

  subnetwork = google_compute_subnetwork.kubernetes.name
}

