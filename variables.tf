variable "GOOGLE_PROJECT" {
  type        = string
  default     = ""
  description = "GCP project name"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = ""
  description = "GCP region to use"
}

variable "GKE_MACHINE_TYPE" {
  type        = string
  default     = ""
  description = "Machine type"
}

variable "GKE_NUM_NODES" {
  type        = number
  default     = 2
  description = "GKE nodes number"
}

variable "GKE_CLUSTER_NAME" {
  type        = string
  default     = ""
  description = "GKE cluster name"
}

variable "GKE_POOL_NAME" {
  type        = string
  default     = ""
  description = "GKE pool name"
}

variable "VPC_NAME" {
  type        = string
  default     = ""
  description = "Name of the VPC network"
}

variable "GKE_SUBNET_CIDR_BLOCK" {
  type        = string
  default     = ""
  description = "CIDR block for the GKE subnet"
}
