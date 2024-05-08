provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
  credentials = file(var.SRVC_JSON)
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "8.1.0"
  project_id   = var.GOOGLE_PROJECT
  network_name = var.VPC_NAME

  subnets = [
    {
      subnet_name   = var.GKE_SUBNET_NAME
      subnet_ip     = var.GKE_SUBNET_CIDR_BLOCK
      subnet_region = var.GOOGLE_REGION
    },
  ]

  secondary_ranges = {
    subnet = [
      {
        range_name    = var.GKE_CLUSTER_PODS_IP_RANGE_NAME
        ip_cidr_range = var.GKE_CLUSTER_PODS_IP_RANGE_CIDR
      },
      {
        range_name    = var.GKE_CLUSTER_SERVICES_IP_RANGE_NAME
        ip_cidr_range = var.GKE_CLUSTER_SERVICES_IP_RANGE_CIDR
      },
    ]
  }
}

module "gke_cluster" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "30.0.0"
  project_id                 = var.GOOGLE_PROJECT
  name                       = var.GKE_CLUSTER_NAME
  region                     = var.GOOGLE_REGION
  network                    = module.gcp-network.network_name
  subnetwork                 = module.gcp-network.subnets_names[0]
  remove_default_node_pool   = true
  deletion_protection        = false
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = false
  filestore_csi_driver       = false
  logging_service            = "logging.googleapis.com/kubernetes"
  ip_range_pods              = var.GKE_CLUSTER_PODS_IP_RANGE_NAME
  ip_range_services          = var.GKE_CLUSTER_SERVICES_IP_RANGE_NAME
  node_pools = [
    {
      name           = var.GKE_POOL_NAME
      machine_type   = var.GKE_MACHINE_TYPE
      node_locations = var.GOOGLE_ZONE
      initial_node_count = var.GKE_NUM_NODES
      min_count      = var.GKE_MIN_COUNT
      max_count      = var.GKE_MIN_COUNT
      disk_size_gb   = 40
      auto_repair    = true
      auto_upgrade   = true
      preemptible    = false
      management = true
      
    }
  ]
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]
  }
  depends_on = [module.gcp-network]
}

module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = var.GOOGLE_PROJECT
  cluster_name         = module.gke_cluster.name
  location             = var.GOOGLE_REGION
  depends_on           = [module.gke_cluster]
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
  file_permission = "0400"
}
