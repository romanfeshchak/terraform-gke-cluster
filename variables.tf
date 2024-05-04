variable "GOOGLE_PROJECT" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "GOOGLE_REGION" {
  description = "The region to deploy resources"
  type        = string
}

variable "GOOGLE_ZONE" {
  description = "The zone to deploy resources"
  type        = string
}

variable "SRVC_JSON" {
  description = "The path to the service account key JSON file"
  type        = string
}

variable "VPC_NAME" {
  description = "The name of the VPC network"
  type        = string
}

variable "GKE_CLUSTER_NAME" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "GKE_SUBNET_NAME" {
  description = "The name of the GKE subnet"
  type        = string
}

variable "GKE_SUBNET_CIDR_BLOCK" {
  description = "The CIDR block for the GKE subnet"
  type        = string
}

variable "GKE_CLUSTER_PODS_IP_RANGE_NAME" {
  description = "Name of the IP range for pods in the GKE cluster"
  type        = string
}

variable "GKE_CLUSTER_SERVICES_IP_RANGE_NAME" {
  description = "Name of the IP range for services in the GKE cluster"
  type        = string
}

variable "GKE_CLUSTER_PODS_IP_RANGE_CIDR" {
  description = "CIDR block for the IP range for pods in the GKE cluster"
  type        = string
}

variable "GKE_CLUSTER_SERVICES_IP_RANGE_CIDR" {
  description = "CIDR block for the IP range for services in the GKE cluster"
  type        = string
}

variable "GKE_MACHINE_TYPE" {
  description = "The machine type for GKE nodes"
  type        = string
}

variable "GKE_POOL_NAME" {
  description = "The name of the GKE node pool"
  type        = string
}

variable "GKE_NUM_NODES" {
  description = "The number of nodes in the GKE node pool"
  type        = number
}
