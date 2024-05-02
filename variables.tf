variable "GOOGLE_PROJECT" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "GOOGLE_REGION" {
  type        = string
  description = "The Google Cloud region where the resources will be created."
}

variable "SRVC_JSON" {
  type        = string
  description = "The path to the service account JSON file for Terraform."
}

variable "GKE_NETWORK" {
  type        = string
  description = "The name of the VPC network to be used."
}

variable "GKE_SUBNETWORK" {
  type        = string
  description = "The name of the GKE subnet."
}

variable "VPC_NAME" {
  type        = string
  description = "The name of the VPC network to be used."
}

variable "GKE_CLUSTER_NAME" {
  type        = string
  description = "The name of the GKE cluster to be created."
}
variable "GKE_POOL_NAME" {
  description = "The name of the node pool in the GKE cluster."
  type        = string
}

variable "GKE_NUM_NODES" {
  type        = number
  description = "The number of nodes in the GKE cluster."
}

variable "GKE_MACHINE_TYPE" {
  type        = string
  description = "The machine type for the GKE nodes."
}

variable "GKE_SUBNET_CIDR_BLOCK" {
  type        = string
  description = "The CIDR block for the GKE subnet."
}

variable "GKE_CLUSTER_PODS_IP_RANGE" {
  type        = string
  description = "The IP range for pods in the GKE cluster."
}

variable "GKE_CLUSTER_SERVICES_IP_RANGE" {
  type        = string
  description = "The IP range for services in the GKE cluster."
}

variable "GKE_PODS_SECONDARY_RANGE_NAME" {
  type        = string
  description = "The name of the secondary IP range for pods in the GKE cluster."
}

variable "GKE_SERVICES_SECONDARY_RANGE_NAME" {
  type        = string
  description = "The name of the secondary IP range for services in the GKE cluster."
}
