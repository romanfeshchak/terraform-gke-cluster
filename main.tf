provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
  credentials = file(var.SRVC_JSON)
}

resource "google_compute_network" "vpc" {
  name                    = var.VPC_NAME
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.GKE_SUBNET_NAME
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = var.GKE_SUBNET_CIDR_BLOCK
  region        = var.GOOGLE_REGION
  secondary_ip_range {
    range_name    = var.GKE_CLUSTER_PODS_IP_RANGE_NAME
    ip_cidr_range = var.GKE_CLUSTER_PODS_IP_RANGE_CIDR
  }
  secondary_ip_range {
    range_name    = var.GKE_CLUSTER_SERVICES_IP_RANGE_NAME
    ip_cidr_range = var.GKE_CLUSTER_SERVICES_IP_RANGE_CIDR
  }
  depends_on = [google_compute_network.vpc]
}
resource "google_container_cluster" "terraincognitus" {
  name                     = var.GKE_CLUSTER_NAME
  location                 = var.GOOGLE_REGION
  initial_node_count       = var.GKE_NUM_NODES
  remove_default_node_pool = true
  depends_on = [google_compute_subnetwork.subnet]
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.GKE_CLUSTER_PODS_IP_RANGE_CIDR
    services_ipv4_cidr_block = var.GKE_CLUSTER_SERVICES_IP_RANGE_CIDR
  }
}

module "gke_cluster" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  project_id        = var.GOOGLE_PROJECT
  region            = var.GOOGLE_REGION
  name              = var.GKE_CLUSTER_NAME
  network           = var.VPC_NAME
  subnetwork        = google_compute_subnetwork.subnet.name
  ip_range_pods     = var.GKE_CLUSTER_PODS_IP_RANGE_NAME
  ip_range_services = var.GKE_CLUSTER_SERVICES_IP_RANGE_NAME

  depends_on               = [google_container_cluster]
  
}



terraform {
  backend "gcs" {
    bucket = "terraforms-state"
    prefix = "terraform/state"
  }
}
