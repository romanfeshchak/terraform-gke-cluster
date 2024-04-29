variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project name"
}

variable "GOOGLE_REGION" {
  type = string
  default     = "europe-central2-b"
  description = "GCP region to use"
}

variable "GKE_MACHINE_TYPE" {
  type = string
  default     = "g1-small"
  description = "Machine type"
}

variable "GKE_NUM_NODES" {
  type = number
  default     = 2
  description = "GKE nodes number"
}

variable "GKE_CLUSTER_NAME" {
  type = string
  default     = "default"
  description = "GKE cluster name"
}

variable "GKE_POOL_NAME" {
  type = string
  default     = "terraincognitus"
  description = "GKE pool name"
}
